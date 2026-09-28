import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scenario.dart';
import '../models/history_log.dart';
import 'identity_service.dart';
import 'cloud_sync_service.dart';

class StorageService {
  static const String _scenariosKey = 'safestep_scenarios';
  static const String _historyKey = 'safestep_history';

  final IdentityService _identity = IdentityService.instance;
  final CloudSyncService _cloud = CloudSyncService.instance;

  // ---------------------------------------------------------------------------
  // SCENARIOS
  // ---------------------------------------------------------------------------

  /// Load scenarios from storage, fallback to default curated scenarios list,
  /// and automatically restore user's custom scenarios from Firestore if available.
  Future<List<Scenario>> loadScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_scenariosKey);
    List<Scenario> list = [];

    if (data == null) {
      list = curatedScenarios
          .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
          .toList();
    } else {
      try {
        final List<dynamic> decoded = json.decode(data);
        list = decoded
            .map((e) => Scenario.fromJson(e as Map<String, dynamic>))
            .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
            .toList();

        // Ensure default scenarios are always present
        final existingIds = list.map((s) => s.id).toSet();
        final List<Scenario> missing = curatedScenarios
            .where((s) => !existingIds.contains(s.id))
            .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
            .toList();
        if (missing.isNotEmpty) {
          list = [...list, ...missing];
          await saveScenarios(list);
        }
      } catch (e) {
        list = curatedScenarios
            .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
            .toList();
      }
    }

    // Background restore of custom scenarios from Cloud Firestore
    _syncCustomScenariosFromCloud(list);

    return list;
  }

  /// Syncs and merges custom scenarios from Firestore into local storage.
  Future<List<Scenario>> _syncCustomScenariosFromCloud(List<Scenario> currentList) async {
    try {
      final userId = await _identity.getOrCreateUserId();
      final cloudCustom = await _cloud.fetchCustomScenarios(userId);
      if (cloudCustom.isNotEmpty) {
        final currentIds = currentList.map((s) => s.id).toSet();
        final List<Scenario> newlyAdded = [];

        for (final cloudScen in cloudCustom) {
          if (!currentIds.contains(cloudScen.id)) {
            newlyAdded.add(cloudScen);
          }
        }

        if (newlyAdded.isNotEmpty) {
          final merged = [...newlyAdded, ...currentList];
          await saveScenarios(merged);
          debugPrint('StorageService: Restored ${newlyAdded.length} custom scenarios from Cloud.');
          return merged;
        }
      }
    } catch (e) {
      debugPrint('StorageService: Cloud scenario sync error: $e');
    }
    return currentList;
  }

  /// Save scenarios to SharedPreferences and sync any custom ones to Firestore.
  Future<void> saveScenarios(List<Scenario> list) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(list.map((s) => s.toJson()).toList());
    await prefs.setString(_scenariosKey, data);
  }

  /// Save a single custom scenario to both local storage and Firestore.
  Future<void> saveCustomScenarioToCloud(Scenario scenario) async {
    try {
      final userId = await _identity.getOrCreateUserId();
      await _cloud.saveCustomScenario(userId, scenario);
    } catch (e) {
      debugPrint('StorageService: Error saving custom scenario to cloud: $e');
    }
  }

  /// Delete a custom scenario from Firestore.
  Future<void> deleteCustomScenarioFromCloud(int id) async {
    try {
      final userId = await _identity.getOrCreateUserId();
      await _cloud.deleteCustomScenario(userId, id);
    } catch (e) {
      debugPrint('StorageService: Error deleting custom scenario from cloud: $e');
    }
  }

  /// Reset to default standard scenarios.
  Future<List<Scenario>> resetToDefaultScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = curatedScenarios
        .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
        .toList();
    final String data = json.encode(normalized.map((s) => s.toJson()).toList());
    await prefs.setString(_scenariosKey, data);
    return normalized;
  }

  // ---------------------------------------------------------------------------
  // HISTORY LOGS (SIMULATION REPORTS)
  // ---------------------------------------------------------------------------

  /// Load simulation history logs:
  /// 1. Reads local cache for instant UI rendering.
  /// 2. If local cache is empty (e.g. after reinstall), pulls from Firestore.
  Future<List<HistoryLog>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_historyKey);
    List<HistoryLog> localLogs = [];

    if (data != null && data.isNotEmpty) {
      try {
        final List<dynamic> decoded = json.decode(data);
        localLogs = decoded
            .map((e) => HistoryLog.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        localLogs = [];
      }
    }

    // If local storage is empty (clean reinstall), try pulling from Cloud Firestore
    if (localLogs.isEmpty) {
      try {
        final userId = await _identity.getOrCreateUserId();
        final cloudLogs = await _cloud.fetchHistory(userId);
        if (cloudLogs.isNotEmpty) {
          debugPrint('StorageService: Restored ${cloudLogs.length} history logs from Firestore.');
          await saveHistory(cloudLogs);
          return cloudLogs;
        }
      } catch (e) {
        debugPrint('StorageService: Error fetching history from cloud: $e');
      }
    }

    return localLogs;
  }

  /// Save history logs locally and push newest additions to Firestore.
  Future<void> saveHistory(List<HistoryLog> list) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(list.map((l) => l.toJson()).toList());
    await prefs.setString(_historyKey, data);
  }

  /// Save a single simulation report log to Firestore.
  Future<void> saveHistoryLogToCloud(HistoryLog log) async {
    try {
      final userId = await _identity.getOrCreateUserId();
      await _cloud.saveHistoryLog(userId, log);
      await _cloud.recordUserActivity(userId);
    } catch (e) {
      debugPrint('StorageService: Error syncing history log to cloud: $e');
    }
  }

  /// Delete a history log from Firestore.
  Future<void> deleteHistoryLogFromCloud(int logId) async {
    try {
      final userId = await _identity.getOrCreateUserId();
      await _cloud.deleteHistoryLog(userId, logId);
    } catch (e) {
      debugPrint('StorageService: Error deleting history log from cloud: $e');
    }
  }

  /// Clear all history logs from Firestore.
  Future<void> clearAllHistoryFromCloud() async {
    try {
      final userId = await _identity.getOrCreateUserId();
      await _cloud.clearAllHistory(userId);
    } catch (e) {
      debugPrint('StorageService: Error clearing all history from cloud: $e');
    }
  }
}
