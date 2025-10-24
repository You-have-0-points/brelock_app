import 'package:uuid/uuid.dart';

class PasswordAnalytics {
  final UuidValue id;
  final DateTime generatedAt;
  final int totalPasswords;
  final int strongPasswords;
  final int mediumPasswords;
  final int weakPasswords;
  final double averagePasswordLength;
  final int reusedPasswordsCount;
  final int oldPasswordsCount;
  final List<PasswordRecommendation> recommendations;

  PasswordAnalytics({
    required this.id,
    required this.generatedAt,
    required this.totalPasswords,
    required this.strongPasswords,
    required this.mediumPasswords,
    required this.weakPasswords,
    required this.averagePasswordLength,
    required this.reusedPasswordsCount,
    required this.oldPasswordsCount,
    required this.recommendations,
  });

  double get strongPercentage => totalPasswords > 0 ? (strongPasswords / totalPasswords) * 100 : 0;
  double get mediumPercentage => totalPasswords > 0 ? (mediumPasswords / totalPasswords) * 100 : 0;
  double get weakPercentage => totalPasswords > 0 ? (weakPasswords / totalPasswords) * 100 : 0;
  double get securityScore {
    double score = 0;
    score += strongPercentage * 1.0;
    score += mediumPercentage * 0.6;
    score += weakPercentage * 0.2;
    return score.clamp(0, 100);
  }
}

class PasswordRecommendation {
  final String title;
  final String description;
  final RecommendationType type;
  final int affectedCount;
  final String action;

  PasswordRecommendation({
    required this.title,
    required this.description,
    required this.type,
    required this.affectedCount,
    required this.action,
  });
}

enum RecommendationType {
  WEAK_PASSWORD,
  REUSED_PASSWORD,
  OLD_PASSWORD,
  NO_SPECIAL_CHARS,
  SHORT_PASSWORD,
}