import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Service responsible for maintaining a persistent, unguessable device/user UUID
/// that survives app uninstallation without requiring manual authentication.
class IdentityService {
  IdentityService._internal();
  static final IdentityService instance = IdentityService._internal();

  static const String _userIdKey = 'safestep_persistent_user_id';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
      synchronizable: true,
    ),
  );

  String? _cachedUserId;

  /// Retrieves the persistent user ID, or creates a new UUID v4 if not found.
  Future<String> getOrCreateUserId() async {
    if (_cachedUserId != null && _cachedUserId!.isNotEmpty) {
      return _cachedUserId!;
    }

    String? id;

    // 1. Try reading from platform-appropriate storage
    try {
      if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
        id = await _secureStorage.read(key: _userIdKey);
      }
    } catch (e) {
      debugPrint('IdentityService: Failed to read from SecureStorage: $e');
    }

    // 2. Try reading from SharedPreferences (Used on Android for Auto Backup & fallback)
    if (id == null || id.isEmpty) {
      try {
        final prefs = await SharedPreferences.getInstance();
        id = prefs.getString(_userIdKey);
      } catch (e) {
        debugPrint('IdentityService: Failed to read from SharedPreferences: $e');
      }
    }

    // 3. If still null, generate a new random UUID v4
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      debugPrint('IdentityService: Generated new persistent UUID: $id');
    } else {
      debugPrint('IdentityService: Retrieved existing persistent UUID: $id');
    }

    // 4. Save to both storage layers to maximize recovery across reinstalls & backups
    await _persistId(id);

    _cachedUserId = id;
    return id;
  }

  /// Helper to persist the ID across both SharedPreferences (Android Auto Backup)
  /// and iOS Keychain (FlutterSecureStorage).
  Future<void> _persistId(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, id);
    } catch (e) {
      debugPrint('IdentityService: Error writing to SharedPreferences: $e');
    }

    try {
      if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
        await _secureStorage.write(key: _userIdKey, value: id);
      }
    } catch (e) {
      debugPrint('IdentityService: Error writing to SecureStorage: $e');
    }
  }

  /// Get currently cached or quick user ID (null if not yet initialized)
  String? get cachedUserId => _cachedUserId;
}
