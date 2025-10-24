import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/domain/entities/password_analytics.dart';
import 'package:brelock/domain/usecases/password_interactor.dart';
import 'package:uuid/uuid.dart';

class PasswordAnalyticsInteractor {
  final PasswordInteractor passwordInteractor;

  PasswordAnalyticsInteractor({required this.passwordInteractor});

  Future<PasswordAnalytics> generateAnalytics(UuidValue consumerId) async {
    try {
      print('🔍 Starting analytics for consumer: $consumerId');
      final passwords = await passwordInteractor.getByIds((await folderInteractor.getById((await folderRepository.getByName("Общее", current_consumer))!.id)).passwordsIds);
      print('📊 Found ${passwords.length} passwords to analyze');

      if (passwords.isEmpty) {
        print('⚠️ No passwords found for analytics');
        return _createEmptyAnalytics();
      }

      final analytics = _analyzePasswords(passwords);
      print('✅ Analytics generated: ${analytics.totalPasswords} passwords analyzed');
      return analytics;
    } catch (e) {
      print('❌ Error in generateAnalytics: $e');
      return _createEmptyAnalytics();
    }
  }

  PasswordAnalytics _createEmptyAnalytics() {
    return PasswordAnalytics(
      id: UuidValue.fromString(Uuid().v4()),
      generatedAt: DateTime.now(),
      totalPasswords: 0,
      strongPasswords: 0,
      mediumPasswords: 0,
      weakPasswords: 0,
      averagePasswordLength: 0,
      reusedPasswordsCount: 0,
      oldPasswordsCount: 0,
      recommendations: [
        PasswordRecommendation(
          title: 'Добавьте пароли',
          description: 'У вас пока нет сохраненных паролей для анализа',
          type: RecommendationType.WEAK_PASSWORD,
          affectedCount: 0,
          action: 'Добавить',
        )
      ],
    );
  }

  PasswordAnalytics _analyzePasswords(List<Password> passwords) {
    print('🔬 Analyzing ${passwords.length} passwords...');

    final total = passwords.length;
    int strong = 0, medium = 0, weak = 0;
    double totalLength = 0;

    // Отладочная информация
    for (final password in passwords) {
      print('🔑 Password: ${password.serviceName.name}, length: ${password.secret.length}');
    }

    final reused = _findReusedPasswords(passwords);
    final old = _findOldPasswords(passwords);

    final recommendations = <PasswordRecommendation>[];

    for (final password in passwords) {
      final strength = _calculatePasswordStrength(password.secret);
      totalLength += password.secret.length;

      switch (strength) {
        case PasswordStrength.STRONG:
          strong++;
          break;
        case PasswordStrength.MEDIUM:
          medium++;
          break;
        case PasswordStrength.WEAK:
          weak++;
          break;
      }
    }

    // Генерация рекомендаций
    if (weak > 0) {
      recommendations.add(PasswordRecommendation(
        title: 'Слабые пароли',
        description: '$weak паролей имеют низкую надежность',
        type: RecommendationType.WEAK_PASSWORD,
        affectedCount: weak,
        action: 'Усилить',
      ));
    }

    if (reused.isNotEmpty) {
      recommendations.add(PasswordRecommendation(
        title: 'Повторяющиеся пароли',
        description: 'Обнаружены повторно используемые пароли',
        type: RecommendationType.REUSED_PASSWORD,
        affectedCount: reused.length,
        action: 'Изменить',
      ));
    }

    if (old.isNotEmpty) {
      recommendations.add(PasswordRecommendation(
        title: 'Устаревшие пароли',
        description: '${old.length} паролей не обновлялись более 6 месяцев',
        type: RecommendationType.OLD_PASSWORD,
        affectedCount: old.length,
        action: 'Обновить',
      ));
    }

    final shortPasswords = passwords.where((p) => p.secret.length < 8).length;
    if (shortPasswords > 0) {
      recommendations.add(PasswordRecommendation(
        title: 'Короткие пароли',
        description: '$shortPasswords паролей короче 8 символов',
        type: RecommendationType.SHORT_PASSWORD,
        affectedCount: shortPasswords,
        action: 'Удлинить',
      ));
    }

    // Если нет рекомендаций, добавить позитивную
    if (recommendations.isEmpty && total > 0) {
      recommendations.add(PasswordRecommendation(
        title: 'Отличная работа!',
        description: 'Все ваши пароли соответствуют рекомендациям безопасности',
        type: RecommendationType.WEAK_PASSWORD,
        affectedCount: 0,
        action: 'Продолжайте в том же духе!',
      ));
    }

    final analytics = PasswordAnalytics(
      id: UuidValue.fromString(Uuid().v4()),
      generatedAt: DateTime.now(),
      totalPasswords: total,
      strongPasswords: strong,
      mediumPasswords: medium,
      weakPasswords: weak,
      averagePasswordLength: total > 0 ? totalLength / total : 0,
      reusedPasswordsCount: reused.length,
      oldPasswordsCount: old.length,
      recommendations: recommendations,
    );

    print('📈 Analytics result: $strong strong, $medium medium, $weak weak');
    return analytics;
  }

  List<Password> _findReusedPasswords(List<Password> passwords) {
    final passwordMap = <String, List<Password>>{};
    for (final password in passwords) {
      passwordMap.putIfAbsent(password.secret, () => []).add(password);
    }
    return passwordMap.values.where((list) => list.length > 1).expand((list) => list).toList();
  }

  List<Password> _findOldPasswords(List<Password> passwords) {
    final sixMonthsAgo = DateTime.now().subtract(Duration(days: 180));
    return passwords.where((password) => password.updatedAt!.isBefore(sixMonthsAgo)).toList();
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.WEAK;

    int score = 0;

    // Длина
    if (password.length >= 12) score += 2;
    else if (password.length >= 8) score += 1;
    else return PasswordStrength.WEAK; // Слишком короткий

    // Сложность
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 1;
    if (RegExp(r'[a-z]').hasMatch(password)) score += 1;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 1;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score += 1;

    if (score >= 5) return PasswordStrength.STRONG;
    if (score >= 3) return PasswordStrength.MEDIUM;
    return PasswordStrength.WEAK;
  }
}

enum PasswordStrength {
  WEAK,
  MEDIUM,
  STRONG
}