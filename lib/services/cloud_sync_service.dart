import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/history_log.dart';
import '../models/scenario.dart';

/// CloudSyncService manages synchronization between SafeStep's local storage
/// and Firebase Firestore under the user's persistent UUID document.
class CloudSyncService {
  CloudSyncService._internal();
  static final CloudSyncService instance = CloudSyncService._internal();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // HISTORY LOGS (SIMULATION REPORTS)
  // ---------------------------------------------------------------------------

  /// Saves or updates a single simulation history log in Firestore.
  Future<void> saveHistoryLog(String userId, HistoryLog log) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('history')
          .doc(log.id.toString())
          .set(log.toJson(), SetOptions(merge: true));
      debugPrint('CloudSyncService: Saved history log #${log.id} to Firestore.');
    } catch (e) {
      debugPrint('CloudSyncService: Error saving history log to Firestore: $e');
    }
  }

  /// Bulk saves all history logs to Firestore (e.g. during initial migration).
  Future<void> syncAllHistory(String userId, List<HistoryLog> logs) async {
    if (logs.isEmpty) return;
    try {
      final batch = _db.batch();
      for (final log in logs) {
        final docRef = _db
            .collection('users')
            .doc(userId)
            .collection('history')
            .doc(log.id.toString());
        batch.set(docRef, log.toJson(), SetOptions(merge: true));
      }
      await batch.commit();
      debugPrint('CloudSyncService: Synced ${logs.length} history logs to Firestore.');
    } catch (e) {
      debugPrint('CloudSyncService: Error bulk syncing history logs: $e');
    }
  }

  /// Fetches all simulation history logs for the given persistent user ID.
  Future<List<HistoryLog>> fetchHistory(String userId) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('history')
          .orderBy('id', descending: true)
          .get();

      final List<HistoryLog> logs = [];
      for (final doc in snapshot.docs) {
        try {
          logs.add(HistoryLog.fromJson(doc.data()));
        } catch (parseErr) {
          debugPrint('CloudSyncService: Error parsing history doc ${doc.id}: $parseErr');
        }
      }
      debugPrint('CloudSyncService: Fetched ${logs.length} history logs from Firestore.');
      return logs;
    } catch (e) {
      debugPrint('CloudSyncService: Error fetching history from Firestore: $e');
      return [];
    }
  }

  /// Deletes a specific history log from Firestore.
  Future<void> deleteHistoryLog(String userId, int logId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('history')
          .doc(logId.toString())
          .delete();
      debugPrint('CloudSyncService: Deleted history log #$logId from Firestore.');
    } catch (e) {
      debugPrint('CloudSyncService: Error deleting history log from Firestore: $e');
    }
  }

  /// Clears all history logs for this user from Firestore.
  Future<void> clearAllHistory(String userId) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('history')
          .get();

      final batch = _db.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      debugPrint('CloudSyncService: Cleared all history logs in Firestore.');
    } catch (e) {
      debugPrint('CloudSyncService: Error clearing history logs: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // CUSTOM SCENARIOS (USER-CREATED)
  // ---------------------------------------------------------------------------

  /// Saves a user-created custom scenario to Firestore.
  Future<void> saveCustomScenario(String userId, Scenario scenario) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('scenarios')
          .doc(scenario.id.toString())
          .set(scenario.toJson(), SetOptions(merge: true));
      debugPrint('CloudSyncService: Saved custom scenario #${scenario.id} to Firestore.');
    } catch (e) {
      debugPrint('CloudSyncService: Error saving custom scenario to Firestore: $e');
    }
  }

  /// Fetches all user-created custom scenarios from Firestore.
  Future<List<Scenario>> fetchCustomScenarios(String userId) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('scenarios')
          .get();

      final List<Scenario> scenarios = [];
      for (final doc in snapshot.docs) {
        try {
          scenarios.add(Scenario.fromJson(doc.data()));
        } catch (parseErr) {
          debugPrint('CloudSyncService: Error parsing custom scenario ${doc.id}: $parseErr');
        }
      }
      debugPrint('CloudSyncService: Fetched ${scenarios.length} custom scenarios from Firestore.');
      return scenarios;
    } catch (e) {
      debugPrint('CloudSyncService: Error fetching custom scenarios: $e');
      return [];
    }
  }

  /// Deletes a custom scenario from Firestore.
  Future<void> deleteCustomScenario(String userId, int scenarioId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('scenarios')
          .doc(scenarioId.toString())
          .delete();
      debugPrint('CloudSyncService: Deleted custom scenario #$scenarioId from Firestore.');
    } catch (e) {
      debugPrint('CloudSyncService: Error deleting custom scenario: $e');
    }
  }

  /// Records user device / last active metadata in the user's root document.
  Future<void> recordUserActivity(String userId) async {
    try {
      await _db.collection('users').doc(userId).set({
        'lastActive': FieldValue.serverTimestamp(),
        'appVersion': '0.1.0',
        'platform': defaultTargetPlatform.name,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('CloudSyncService: Failed to record user activity: $e');
    }
  }
}
