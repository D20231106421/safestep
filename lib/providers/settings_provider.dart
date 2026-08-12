import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _enableAlerts = true;
  bool _simulateNotifications = true;
  String _alertFrequency = 'Tinggi';
  Map<String, String>? _activePush;

  ThemeMode _themeMode = ThemeMode.dark;

  bool get enableAlerts => _enableAlerts;
  // Alias for TrendsView toggle
  bool get liveAlertsEnabled => _enableAlerts;
  bool get simulateNotifications => _simulateNotifications;
  String get alertFrequency => _alertFrequency;
  Map<String, String>? get activePush => _activePush;
  ThemeMode get themeMode => _themeMode;

  static const String _prefThemeMode = 'theme_mode';

  final List<Map<String, String>> _sampleAlerts = [
    {
      'id': '1',
      'title': '🚨 SafeStep Amaran: Macau Scam',
      'body': 'Waspada panggilan telefon dari Bukit Aman kononnya akaun anda dibekukan. PDRM tidak siasat guna telefon!'
    },
    {
      'id': '2',
      'title': '💡 SafeStep Tips Keselamatan',
      'body': 'Jangan dedahkan kod SMS TAC bank anda. Kakitangan Maybank/CIMB tidak akan memintanya.'
    },
    {
      'id': '3',
      'title': '🔥 Amaran Trend: LHDN Palsu',
      'body': 'SMS menawarkan bayaran balik cukai mengandungi pautan ganjil \'.top\' sedang merebak. Abaikan segera!'
    },
    {
      'id': '4',
      'title': '🛡️ SafeStep Amaran APK',
      'body': 'Jangan sesekali memasang fail aplikasi (.apk) yang dihantar melalui chat orang asing. Risiko peranti digodam!'
    }
  ];

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
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
      notifyListeners();
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
      _activePush = null;
    }
    notifyListeners();
  }

  // Alias for TrendsView
  void setLiveAlerts(bool value) => setEnableAlerts(value);

  void setSimulateNotifications(bool value) {
    _simulateNotifications = value;
    notifyListeners();
  }

  void setAlertFrequency(String value) {
    _alertFrequency = value;
    notifyListeners();
  }

  void triggerRandomAlert() {
    if (!_enableAlerts) return;
    final random = Random();
    _activePush = _sampleAlerts[random.nextInt(_sampleAlerts.length)];
    notifyListeners();
  }

  void dismissAlert() {
    _activePush = null;
    notifyListeners();
  }
}
