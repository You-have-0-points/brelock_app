import 'package:brelock/domain/entities/breach_check_result.dart';
import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/domain/usecases/password_interactor.dart';
import 'package:uuid/uuid.dart';

class BreachCheckInteractor {
  final PasswordInteractor passwordInteractor;

  BreachCheckInteractor({required this.passwordInteractor});

  Future<BreachCheckResult> checkForBreaches(List<Password> passwords) async {
    // Имитация проверки утечек
    // В реальном приложении здесь был бы вызов API типа Have I Been Pwned

    await Future.delayed(Duration(seconds: 2)); // Имитация задержки сети

    final compromisedPasswords = <CompromisedPassword>[];

    // Имитация проверки - в реальности здесь был бы хеширование и проверка через API
    for (final password in passwords) {
      // Простая имитация - считаем скомпрометированными пароли короче 6 символов
      // и содержащие простые комбинации
      if (_isWeakPassword(password.secret) || _isCommonPassword(password.secret)) {
        compromisedPasswords.add(CompromisedPassword(
          serviceName: password.serviceName.name,
          login: password.login,
          breachSource: 'Common password database',
          breachDate: DateTime.now().subtract(Duration(days: 30)),
        ));
      }
    }

    return BreachCheckResult(
      id: UuidValue.fromString(Uuid().v4()),
      checkedAt: DateTime.now(),
      totalPasswords: passwords.length,
      compromisedCount: compromisedPasswords.length,
      compromisedPasswords: compromisedPasswords,
    );
  }

  bool _isWeakPassword(String password) {
    return password.length < 6;
  }

  bool _isCommonPassword(String password) {
    const commonPasswords = [
      '123456', 'password', '12345678', 'qwerty', '123456789',
      '12345', '1234', '111111', '1234567', 'dragon',
      '123123', 'baseball', 'abc123', 'football', 'monkey',
      'letmein', '696969', 'shadow', 'master', '666666'
    ];
    return commonPasswords.contains(password.toLowerCase());
  }

  Future<BreachCheckResult> checkAllPasswords(UuidValue consumerId) async {
    final passwords = await passwordInteractor.getAll(consumerId);
    return checkForBreaches(passwords);
  }
}