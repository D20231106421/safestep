import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scenario.dart';
import '../models/history_log.dart';

class StorageService {
  static const String _scenariosKey = 'safestep_scenarios';
  static const String _historyKey = 'safestep_history';

  // Load scenarios from storage, or fallback to default curated scenarios list
  Future<List<Scenario>> loadScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_scenariosKey);
    if (data == null) {
      return curatedScenarios
          .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
          .toList();
    }
    try {
      final List<dynamic> decoded = json.decode(data);
      final list = decoded
          .map((e) => Scenario.fromJson(e as Map<String, dynamic>))
          .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
          .toList();
      
      // Ensure default scenarios are always present (matching React logic)
      final existingIds = list.map((s) => s.id).toSet();
      final List<Scenario> missing = curatedScenarios
          .where((s) => !existingIds.contains(s.id))
          .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
          .toList();
      if (missing.isNotEmpty) {
        final merged = [...list, ...missing];
        await saveScenarios(merged);
        return merged;
      }
      final normalized = list;
      if (json.encode(normalized.map((s) => s.toJson()).toList()) != data) {
        await saveScenarios(normalized);
      }
      return normalized;
    } catch (e) {
      return curatedScenarios
          .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
          .toList();
    }
  }

  // Save scenarios to SharedPreferences
  Future<void> saveScenarios(List<Scenario> list) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(list.map((s) => s.toJson()).toList());
    await prefs.setString(_scenariosKey, data);
  }

  // Reset to default standard scenarios
  Future<List<Scenario>> resetToDefaultScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = curatedScenarios
        .map((s) => s.copyWith(category: normalizeCategoryLabel(s.category)))
        .toList();
    final String data = json.encode(normalized.map((s) => s.toJson()).toList());
    await prefs.setString(_scenariosKey, data);
    return normalized;
  }

  // Load simulation history logs
  Future<List<HistoryLog>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_historyKey);
    if (data == null) {
      return [];
    }
    try {
      final List<dynamic> decoded = json.decode(data);
      return decoded.map((e) => HistoryLog.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  // Save history logs to SharedPreferences
  Future<void> saveHistory(List<HistoryLog> list) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(list.map((l) => l.toJson()).toList());
    await prefs.setString(_historyKey, data);
  }
}
