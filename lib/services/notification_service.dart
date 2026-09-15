import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Singleton service that manages real system push notifications
/// using the flutter_local_notifications plugin.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // ── Notification channel ───────────────────────────────────────────────────
  static const _channelId = 'safestep_alerts';
  static const _channelName = 'SafeStep Amaran';
  static const _channelDesc =
      'Notifikasi amaran scam dan tips keselamatan siber SafeStep';

  // ── Sample alert content ───────────────────────────────────────────────────
  static const List<Map<String, String>> _sampleAlerts = [
    {
      'title': 'Peringatan: Hati-Hati Dengan Penipuan',
      'body': 'Jangan mudah percaya pada mesej atau panggilan yang mencurigakan. Semak dahulu sebelum bertindak',
    },
    {
      'title': 'Peringatan: Jangan Terburu-buru',
      'body': 'Penipu mungkin cuba membuat anda panik. Bertenang dan fikir dahulu sebelum memberi maklumat',
    },
    {
      'title': 'Peringatan: Lindungi Maklumat Anda',
      'body': 'Jangan berikan OTP, kata laluan atau maklumat bank kepada sesiapa',
    },
    {
      'title': 'Peringatan: Tawaran Terlalu Menarik?',
      'body': 'Jika tawaran terlalu bagus untuk dipercayai, semak dahulu. Jangan terus membuat bayaran',
    },
    {
      'title': 'Peringatan: Panggilan Mencurigakan?',
      'body': 'Jika seseorang meminta wang atau maklumat peribadi, hentikan perbualan dan semak dengan keluarga.',
    },
    {
      'title': 'Peringatan: Ingat, Penipu Boleh Menyamar',
      'body': 'Penipu boleh menyamar sebagai bank, polis atau orang yang anda kenali. Sentiasa semak sebelum percaya.',
    },
  ];

  // ── Init ───────────────────────────────────────────────────────────────────

  /// Call once during app startup (before any notification is fired).
  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request Android 13+ POST_NOTIFICATIONS permission
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
    }

    // Request iOS permission
    final iosPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    _initialized = true;
    debugPrint('[NotificationService] Initialized successfully.');
  }

  // ── Show notification ──────────────────────────────────────────────────────

  /// Fires a random scam-alert system notification immediately.
  Future<void> showRandomAlert() async {
    if (!_initialized) {
      debugPrint('[NotificationService] Not initialized — skipping alert.');
      return;
    }

    final alert = _sampleAlerts[Random().nextInt(_sampleAlerts.length)];
    final id = Random().nextInt(100000);

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'SafeStep Amaran',
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
      color: Color(0xFF10B981), // emerald accent
      icon: '@mipmap/ic_launcher',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _plugin.show(
      id,
      alert['title'],
      alert['body'],
      details,
    );

    debugPrint('[NotificationService] Fired notification: ${alert['title']}');
  }

  // ── Cancel all ────────────────────────────────────────────────────────────

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── Tap handler ───────────────────────────────────────────────────────────

  void _onNotificationTap(NotificationResponse response) {
    // App is brought to foreground when user taps; nothing extra needed.
    debugPrint(
        '[NotificationService] Notification tapped: ${response.payload}');
  }
}
