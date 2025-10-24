// lib/presentation/features/splash/splash_screen.dart
import 'package:brelock/di_injector.dart';
import 'package:brelock/presentation/features/login/screens/login_screen.dart';
import 'package:brelock/presentation/features/password_list/screens/password_list_screen.dart';
import 'package:brelock/services/local_storage_service.dart';
import 'package:brelock/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';
import 'package:uuid/uuid_value.dart';

import '../../../domain/entities/consumer_setting.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Имитация минимального времени загрузки
      await Future.delayed(Duration(milliseconds: 1500));

      // Проверяем сохраненные учетные данные
      final credentials = await LocalStorageService.getUserCredentials();

      if (credentials != null && mounted) {
        // Пытаемся загрузить пользователя из кэша или сети
        await _loadUserFromCacheOrNetwork(credentials);
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    } catch (e) {
      print('Error during app initialization: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  Future<void> _loadUserFromCacheOrNetwork(Map<String, String> credentials) async {
    try {
      final isConnected = await ConnectivityService.isConnected();

      if (!isConnected) {
        // Офлайн режим - загружаем из кэша
        print('📴 Offline mode - loading from cache');
        await _loadUserFromCache(credentials);
      } else {
        // Онлайн режим - пытаемся загрузить из сети
        print('📡 Online mode - loading from network');
        await _loadUserFromNetwork(credentials);
      }
    } catch (e) {
      print('❌ Error loading user: $e');
      // При ошибке пытаемся загрузить из кэша
      await _loadUserFromCache(credentials);
    }
  }

  Future<void> _loadUserFromCache(Map<String, String> credentials) async {
    try {
      final cachedUserData = await LocalStorageService.getCachedUserData();

      if (cachedUserData != null) {
        print('✅ Loaded user from cache');
        // Восстанавливаем пользователя из кэша
        _restoreUserFromCache(cachedUserData);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PasswordListScreen()),
          );
        }
      } else {
        // Если кэша нет, переходим к логину
        print('❌ No cached user data found');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    } catch (e) {
      print('❌ Error loading user from cache: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  Future<void> _loadUserFromNetwork(Map<String, String> credentials) async {
    try {
      final consumer = await consumerRepository.getByIdString(credentials['id']!);
      if (consumer != null) {
        current_consumer.copy(consumer);

        // Сохраняем в кэш
        await _cacheUserData();

        print('✅ Loaded user from network and cached');

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PasswordListScreen()),
          );
        }
      } else {
        // Если пользователь не найден, очищаем кэш и переходим к логину
        await LocalStorageService.clearUserCredentials();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    } catch (e) {
      print('❌ Error loading user from network: $e');
      // При ошибке сети пытаемся загрузить из кэша
      await _loadUserFromCache(credentials);
    }
  }

  void _restoreUserFromCache(Map<String, dynamic> userData) {
    try {
      // Восстанавливаем основные поля пользователя
      current_consumer.id = UuidValue.fromString(userData['id'] ?? '');
      current_consumer.email = userData['email'];
      current_consumer.password = userData['password'];

      // Восстанавливаем настройки
      if (userData['setting'] != null) {
        final settingData = userData['setting'];
        // Здесь нужно восстановить ConsumerSetting из данных
      }

      // Восстанавливаем folder_ids
      if (userData['folder_ids'] != null) {
        final folderIds = (userData['folder_ids'] as List<dynamic>)
            .map((id) => UuidValue.fromString(id.toString()))
            .toList();
        current_consumer.folderIds = folderIds;
      }

      // Восстанавливаем двухфакторную аутентификацию
      current_consumer.twoFactorEnabled = userData['two_factor_enabled'] ?? false;
      current_consumer.twoFactorSecret = userData['two_factor_secret'];

      if (userData['two_factor_enabled_at'] != null) {
        current_consumer.twoFactorEnabledAt = DateTime.parse(userData['two_factor_enabled_at']);
      }

      if (userData['created_at'] != null) {
        current_consumer.createdAt = DateTime.parse(userData['created_at']);
      }

      if (userData['logged_at'] != null) {
        current_consumer.loggedAt = DateTime.parse(userData['logged_at']);
      }

      print('✅ User restored from cache: ${current_consumer.email}');
    } catch (e) {
      print('❌ Error restoring user from cache: $e');
      throw e;
    }
  }

  Future<void> _cacheUserData() async {
    try {
      final userData = {
        'id': current_consumer.id?.uuid,
        'email': current_consumer.email,
        'password': current_consumer.password,
        'setting': _settingToMap(current_consumer.setting),
        'folder_ids': current_consumer.folderIds?.map((id) => id.uuid).toList(),
        'two_factor_enabled': current_consumer.twoFactorEnabled,
        'two_factor_secret': current_consumer.twoFactorSecret,
        'two_factor_enabled_at': current_consumer.twoFactorEnabledAt?.toIso8601String(),
        'created_at': current_consumer.createdAt?.toIso8601String(),
        'logged_at': current_consumer.loggedAt?.toIso8601String(),
      };

      await LocalStorageService.cacheUserData(userData);
      print('✅ User data cached successfully');
    } catch (e) {
      print('❌ Error caching user data: $e');
    }
  }

  Map<String, dynamic>? _settingToMap(ConsumerSetting? setting) {
    if (setting == null) return null;

    return {
      'theme': setting.theme.toString(),
      'language': setting.language.toString(),
      'auto_lock_timeout': setting.autoLockTimeout.inMinutes,
      'show_password_strength': setting.showPasswordStrength,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Загрузка...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}