import 'package:uuid/uuid.dart';

class BreachCheckResult {
  final UuidValue id;
  final DateTime checkedAt;
  final int totalPasswords;
  final int compromisedCount;
  final List<CompromisedPassword> compromisedPasswords;

  BreachCheckResult({
    required this.id,
    required this.checkedAt,
    required this.totalPasswords,
    required this.compromisedCount,
    required this.compromisedPasswords,
  });

  bool get hasCompromisedPasswords => compromisedCount > 0;
  bool get isSafe => compromisedCount == 0;
}

class CompromisedPassword {
  final String serviceName;
  final String login;
  final String breachSource;
  final DateTime breachDate;

  CompromisedPassword({
    required this.serviceName,
    required this.login,
    required this.breachSource,
    required this.breachDate,
  });
}