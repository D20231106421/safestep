import 'package:flutter/foundation.dart';
import '../models/history_log.dart';
import '../services/storage_service.dart';

class HistoryProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<HistoryLog> _historyLogs = [];
  bool _isLoading = false;

  List<HistoryLog> get historyLogs => _historyLogs;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _historyLogs = await _storageService.loadHistory();
      // Sort: newest first
      _historyLogs.sort((a, b) => b.id.compareTo(a.id));
    } catch (_) {
      _historyLogs = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLog(HistoryLog log) async {
    _historyLogs.insert(0, log);
    notifyListeners();
    await _storageService.saveHistory(_historyLogs);
  }

  Future<void> deleteLog(int id) async {
    _historyLogs.removeWhere((log) => log.id == id);
    notifyListeners();
    await _storageService.saveHistory(_historyLogs);
  }

  Future<void> clearAllLogs() async {
    _historyLogs.clear();
    notifyListeners();
    await _storageService.saveHistory(_historyLogs);
  }
}
