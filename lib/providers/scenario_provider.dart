import 'package:flutter/foundation.dart';
import '../models/scenario.dart';
import '../services/storage_service.dart';

class ScenarioProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Scenario> _masterScenarios = [];
  bool _isLoading = false;

  List<Scenario> get masterScenarios => _masterScenarios;
  bool get isLoading => _isLoading;

  Future<void> loadScenarios() async {
    _isLoading = true;
    notifyListeners();
    _masterScenarios = await _storageService.loadScenarios();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveScenario(Scenario scenario, {bool isEdit = false}) async {
    if (isEdit) {
      final index = _masterScenarios.indexWhere((s) => s.id == scenario.id);
      if (index != -1) {
        _masterScenarios[index] = scenario;
      }
    } else {
      _masterScenarios.insert(0, scenario);
    }
    notifyListeners();
    await _storageService.saveScenarios(_masterScenarios);
  }

  Future<void> deleteScenario(int id) async {
    _masterScenarios.removeWhere((s) => s.id == id);
    notifyListeners();
    await _storageService.saveScenarios(_masterScenarios);
  }

  Future<void> toggleScenarioActive(int id) async {
    final index = _masterScenarios.indexWhere((s) => s.id == id);
    if (index != -1) {
      _masterScenarios[index] = _masterScenarios[index].copyWith(
        isActive: !_masterScenarios[index].isActive,
      );
      notifyListeners();
      await _storageService.saveScenarios(_masterScenarios);
    }
  }

  Future<void> resetToDefault() async {
    _isLoading = true;
    notifyListeners();
    _masterScenarios = await _storageService.resetToDefaultScenarios();
    _isLoading = false;
    notifyListeners();
  }
}
