import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/history_log.dart';
import '../models/scenario.dart';
import '../supabase_options.dart';

/// CloudSyncService manages synchronization between SafeStep's local storage
/// and Supabase PostgreSQL under the user's persistent UUID.
class CloudSyncService {
  CloudSyncService._internal();
  static final CloudSyncService instance = CloudSyncService._internal();

  static const String _usersTable = 'users';
  static const String _historyTable = 'history_logs';
  static const String _scenariosTable = 'custom_scenarios';

  SupabaseClient? get _client =>
      SupabaseOptions.isConfigured ? Supabase.instance.client : null;

  Future<void> _ensureUserExists(SupabaseClient client, String userId) async {
    await client.from(_usersTable).upsert({
      'id': userId,
      'last_active': DateTime.now().toUtc().toIso8601String(),
      'app_version': '0.1.0',
      'platform': defaultTargetPlatform.name,
    }, onConflict: 'id');
  }

  Map<String, dynamic> _historyToRow(String userId, HistoryLog log) => {
        'user_id': userId,
        'id': log.id,
        'date': log.date,
        'score': log.score,
        'total': log.total,
        'shields': log.shields,
        'status': log.status,
        'results': log.results.map((r) => r.toJson()).toList(),
      };

  HistoryLog _rowToHistory(Map<String, dynamic> row) => HistoryLog.fromJson({
        'id': (row['id'] as num).toInt(),
        'date': row['date'],
        'score': (row['score'] as num).toInt(),
        'total': (row['total'] as num).toInt(),
        'shields': (row['shields'] as num).toInt(),
        'status': row['status'],
        'results': row['results'],
      });

  Map<String, dynamic> _scenarioToRow(String userId, Scenario scenario) => {
        'user_id': userId,
        'id': scenario.id,
        'is_active': scenario.isActive,
        'type': scenario.type,
        'category': scenario.category,
        'technique': scenario.technique,
        'sender': scenario.sender,
        'timestamp': scenario.timestamp,
        'message': scenario.message,
        'is_scam': scenario.isScam,
        'explanation': scenario.explanation,
        'recommended_actions': scenario.recommendedActions,
        'reply_options': scenario.replyOptions.map((o) => o.toJson()).toList(),
      };

  Scenario _rowToScenario(Map<String, dynamic> row) => Scenario.fromJson({
        'id': (row['id'] as num).toInt(),
        'isActive': row['is_active'],
        'type': row['type'],
        'category': row['category'],
        'technique': row['technique'],
        'sender': row['sender'],
        'timestamp': row['timestamp'],
        'message': row['message'],
        'isScam': row['is_scam'],
        'explanation': row['explanation'],
        'recommendedActions': row['recommended_actions'],
        'replyOptions': row['reply_options'],
      });

  // ---------------------------------------------------------------------------
  // HISTORY LOGS (SIMULATION REPORTS)
  // ---------------------------------------------------------------------------

  /// Saves or updates a single simulation history log in Supabase.
  Future<void> saveHistoryLog(String userId, HistoryLog log) async {
    final client = _client;
    if (client == null) return;
    try {
      await _ensureUserExists(client, userId);
      await client
          .from(_historyTable)
          .upsert(_historyToRow(userId, log), onConflict: 'user_id,id');
      debugPrint('CloudSyncService: Saved history log #${log.id} to Supabase.');
    } catch (e) {
      debugPrint('CloudSyncService: Error saving history log to Supabase: $e');
    }
  }

  /// Bulk saves all history logs to Supabase (e.g. during initial migration).
  Future<void> syncAllHistory(String userId, List<HistoryLog> logs) async {
    final client = _client;
    if (client == null || logs.isEmpty) return;
    try {
      await _ensureUserExists(client, userId);
      final rows = logs.map((log) => _historyToRow(userId, log)).toList();
      await client.from(_historyTable).upsert(rows, onConflict: 'user_id,id');
      debugPrint('CloudSyncService: Synced ${logs.length} history logs to Supabase.');
    } catch (e) {
      debugPrint('CloudSyncService: Error bulk syncing history logs: $e');
    }
  }

  /// Fetches all simulation history logs for the given persistent user ID.
  Future<List<HistoryLog>> fetchHistory(String userId) async {
    final client = _client;
    if (client == null) return [];
    try {
      final rows = await client
          .from(_historyTable)
          .select()
          .eq('user_id', userId)
          .order('id', ascending: false);

      final List<HistoryLog> logs = [];
      for (final row in rows) {
        try {
          logs.add(_rowToHistory(row));
        } catch (parseErr) {
          debugPrint('CloudSyncService: Error parsing history row ${row['id']}: $parseErr');
        }
      }
      debugPrint('CloudSyncService: Fetched ${logs.length} history logs from Supabase.');
      return logs;
    } catch (e) {
      debugPrint('CloudSyncService: Error fetching history from Supabase: $e');
      return [];
    }
  }

  /// Deletes a specific history log from Supabase.
  Future<void> deleteHistoryLog(String userId, int logId) async {
    final client = _client;
    if (client == null) return;
    try {
      await client
          .from(_historyTable)
          .delete()
          .eq('user_id', userId)
          .eq('id', logId);
      debugPrint('CloudSyncService: Deleted history log #$logId from Supabase.');
    } catch (e) {
      debugPrint('CloudSyncService: Error deleting history log from Supabase: $e');
    }
  }

  /// Clears all history logs for this user from Supabase.
  Future<void> clearAllHistory(String userId) async {
    final client = _client;
    if (client == null) return;
    try {
      await client.from(_historyTable).delete().eq('user_id', userId);
      debugPrint('CloudSyncService: Cleared all history logs in Supabase.');
    } catch (e) {
      debugPrint('CloudSyncService: Error clearing history logs: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // CUSTOM SCENARIOS (USER-CREATED)
  // ---------------------------------------------------------------------------

  /// Saves a user-created custom scenario to Supabase.
  Future<void> saveCustomScenario(String userId, Scenario scenario) async {
    final client = _client;
    if (client == null) return;
    try {
      await _ensureUserExists(client, userId);
      await client
          .from(_scenariosTable)
          .upsert(_scenarioToRow(userId, scenario), onConflict: 'user_id,id');
      debugPrint('CloudSyncService: Saved custom scenario #${scenario.id} to Supabase.');
    } catch (e) {
      debugPrint('CloudSyncService: Error saving custom scenario to Supabase: $e');
    }
  }

  /// Fetches all user-created custom scenarios from Supabase.
  Future<List<Scenario>> fetchCustomScenarios(String userId) async {
    final client = _client;
    if (client == null) return [];
    try {
      final rows = await client
          .from(_scenariosTable)
          .select()
          .eq('user_id', userId);

      final List<Scenario> scenarios = [];
      for (final row in rows) {
        try {
          scenarios.add(_rowToScenario(row));
        } catch (parseErr) {
          debugPrint('CloudSyncService: Error parsing custom scenario ${row['id']}: $parseErr');
        }
      }
      debugPrint('CloudSyncService: Fetched ${scenarios.length} custom scenarios from Supabase.');
      return scenarios;
    } catch (e) {
      debugPrint('CloudSyncService: Error fetching custom scenarios: $e');
      return [];
    }
  }

  /// Deletes a custom scenario from Supabase.
  Future<void> deleteCustomScenario(String userId, int scenarioId) async {
    final client = _client;
    if (client == null) return;
    try {
      await client
          .from(_scenariosTable)
          .delete()
          .eq('user_id', userId)
          .eq('id', scenarioId);
      debugPrint('CloudSyncService: Deleted custom scenario #$scenarioId from Supabase.');
    } catch (e) {
      debugPrint('CloudSyncService: Error deleting custom scenario: $e');
    }
  }

  /// Records user device / last active metadata in the users table.
  Future<void> recordUserActivity(String userId) async {
    final client = _client;
    if (client == null) return;
    try {
      await _ensureUserExists(client, userId);
    } catch (e) {
      debugPrint('CloudSyncService: Failed to record user activity: $e');
    }
  }
}
