// lib/services/local_storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userDataKey = 'user_data';
  static const String _passwordsDataKey = 'passwords_data';
  static const String _foldersDataKey = 'folders_data';
  static const String _lastSyncKey = 'last_sync';

  // Сохранение полных данных пользователя
  static Future<void> cacheUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, json.encode(userData));
  }

  static Future<Map<String, dynamic>?> getCachedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_userDataKey);
    if (jsonData != null) {
      try {
        return json.decode(jsonData) as Map<String, dynamic>;
      } catch (e) {
        print('Error decoding cached user data: $e');
      }
    }
    return null;
  }

  // Остальные методы остаются такими же...
  static Future<void> saveUserCredentials(String userId, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userEmailKey, email);
  }

  static Future<Map<String, String>?> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey);
    final email = prefs.getString(_userEmailKey);

    if (userId != null && email != null) {
      return {
        'id': userId,
        'email': email,
      };
    }
    return null;
  }

  static Future<void> clearUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_passwordsDataKey);
    await prefs.remove(_foldersDataKey);
    await prefs.remove(_lastSyncKey);
  }

  // Кэширование паролей
  static Future<void> cachePasswords(List<Map<String, dynamic>> passwords) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(passwords);
    await prefs.setString(_passwordsDataKey, jsonData);
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  static Future<List<Map<String, dynamic>>?> getCachedPasswords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_passwordsDataKey);
    if (jsonData != null) {
      try {
        final List<dynamic> decoded = json.decode(jsonData);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        print('Error decoding cached passwords: $e');
      }
    }
    return null;
  }

  // Кэширование папок
  static Future<void> cacheFolders(List<Map<String, dynamic>> folders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(folders);
    await prefs.setString(_foldersDataKey, jsonData);
  }

  static Future<List<Map<String, dynamic>>?> getCachedFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_foldersDataKey);
    if (jsonData != null) {
      try {
        final List<dynamic> decoded = json.decode(jsonData);
        return decoded.cast<Map<String, dynamic>>();
      } catch (e) {
        print('Error decoding cached folders: $e');
      }
    }
    return null;
  }

  static Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getString(_lastSyncKey);
    if (lastSync != null) {
      return DateTime.parse(lastSync);
    }
    return null;
  }

  // В lib/services/local_storage_service.dart добавьте:
  static Future<void> cacheAllPasswords(List<Map<String, dynamic>> passwords) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(passwords);
    await prefs.setString(_passwordsDataKey, jsonData);
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    print('✅ Cached ${passwords.length} passwords');
  }

  static Future<List<Map<String, dynamic>>?> getCachedAllPasswords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_passwordsDataKey);
    if (jsonData != null) {
      try {
        final List<dynamic> decoded = json.decode(jsonData);
        final result = decoded.cast<Map<String, dynamic>>();
        print('📖 Retrieved ${result.length} passwords from cache');
        return result;
      } catch (e) {
        print('❌ Error decoding cached passwords: $e');
      }
    }
    return null;
  }
}