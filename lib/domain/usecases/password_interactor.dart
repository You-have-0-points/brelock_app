
import 'package:brelock/data/repositories/password_repository.dart';
import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/domain/value_objects/service.dart';
import 'package:uuid/uuid.dart';

class PasswordInteractor{
  final PasswordRepository passwordRepository;

  PasswordInteractor(this.passwordRepository);

  Future<Password> create(String url, String login, String password, String name, UuidValue consumerId) async{
    Password new_password = Password(
        id: UuidValue.fromString(Uuid().v4()),
        serviceName: Service(name, url, null),
        login: login,
        secret: password,
        isFavourite: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userId: consumerId
    );
    await passwordRepository.create(new_password);
    return new_password;
  }

  Future<List<Password>> getAll(UuidValue consumerId) async {
    return await passwordRepository.getAll(consumerId);
  }

  Future<List<Password>> getByIds(List<UuidValue> passwordIds) async {
    final passwords = await Future.wait(
        passwordIds.map((id) => passwordRepository.get(id))
    );

    passwords.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return passwords;
  }

  Future<void> update(Password password) async{
    await passwordRepository.update(password);
  }

  Future<void> delete(Password password) async{
    await passwordRepository.delete(password.id);
  }
}