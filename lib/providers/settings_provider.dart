import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class SettingsProvider with ChangeNotifier {
  bool _enableAlerts = true;
  bool _simulateNotifications = true;
  String _alertFrequency = 'Sederhana';

  ThemeMode _themeMode = ThemeMode.dark;

  Timer? _simulationTimer;

  bool get enableAlerts => _enableAlerts;
  // Alias for TrendsView toggle
  bool get liveAlertsEnabled => _enableAlerts;
  bool get simulateNotifications => _simulateNotifications;
  String get alertFrequency => _alertFrequency;
  ThemeMode get themeMode => _themeMode;

  /// All selectable frequency labels.
  static const List<String> frequencyOptions = [
    'Tinggi',
    'Sederhana',
    'Rendah',
    'Mati',
  ];

  /// Returns the periodic interval in seconds for the active frequency.
  /// Returns -1 when 'Mati' (off).
  int get notificationIntervalSeconds {
    switch (_alertFrequency) {
      case 'Tinggi':
        return 15;
      case 'Sederhana':
        return 45;
      case 'Rendah':
        return 90;
      default:
        return -1;
    }
  }

  // ── SharedPreferences keys ─────────────────────────────────────────────────
  static const String _prefThemeMode = 'theme_mode';
  static const String _prefEnableAlerts = 'enable_alerts';
  static const String _prefSimulateNotifications = 'simulate_notifications';
  static const String _prefAlertFrequency = 'alert_frequency';

  // ── Persistence ────────────────────────────────────────────────────────────

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Theme
      final savedTheme = prefs.getString(_prefThemeMode);
      if (savedTheme != null) {
        if (savedTheme == 'light') {
          _themeMode = ThemeMode.light;
        } else if (savedTheme == 'dark') {
          _themeMode = ThemeMode.dark;
        } else if (savedTheme == 'system') {
          _themeMode = ThemeMode.system;
        }
      }

      // Notifications
      _enableAlerts = prefs.getBool(_prefEnableAlerts) ?? true;
      _simulateNotifications =
          prefs.getBool(_prefSimulateNotifications) ?? true;
      _alertFrequency =
          prefs.getString(_prefAlertFrequency) ?? 'Sederhana';

      notifyListeners();
      _restartTimer();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      String val = 'dark';
      if (mode == ThemeMode.light) val = 'light';
      if (mode == ThemeMode.system) val = 'system';
      await prefs.setString(_prefThemeMode, val);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  void setEnableAlerts(bool value) {
    _enableAlerts = value;
    if (!_enableAlerts) {
      _stopTimer();
    } else {
      _restartTimer();
    }
    notifyListeners();
    _saveNotificationPrefs();
  }

  // Alias for TrendsView
  void setLiveAlerts(bool value) => setEnableAlerts(value);

  void setSimulateNotifications(bool value) {
    _simulateNotifications = value;
    if (_simulateNotifications) {
      _restartTimer();
    } else {
      _stopTimer();
    }
    notifyListeners();
    _saveNotificationPrefs();
  }

  void setAlertFrequency(String value) {
    _alertFrequency = value;
    _restartTimer();
    notifyListeners();
    _saveNotificationPrefs();
  }

  /// Fires a real system notification immediately (called by the CUBA button).
  Future<void> triggerRandomAlert() async {
    if (!_enableAlerts) return;
    await NotificationService.instance.showRandomAlert();
  }

  // ── Timer management ───────────────────────────────────────────────────────

  void _restartTimer() {
    _stopTimer();
    final intervalSecs = notificationIntervalSeconds;
    if (!_simulateNotifications || !_enableAlerts || intervalSecs < 0) return;

    _simulationTimer =
        Timer.periodic(Duration(seconds: intervalSecs), (_) async {
      await NotificationService.instance.showRandomAlert();
    });
  }

  void _stopTimer() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  Future<void> _saveNotificationPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefEnableAlerts, _enableAlerts);
      await prefs.setBool(_prefSimulateNotifications, _simulateNotifications);
      await prefs.setString(_prefAlertFrequency, _alertFrequency);
    } catch (e) {
      debugPrint('Error saving notification prefs: $e');
    }
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
