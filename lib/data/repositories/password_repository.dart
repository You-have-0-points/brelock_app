import 'package:brelock/data/data_sources/password_datasource.dart';
import 'package:brelock/data/translators/password_translator.dart';
import 'package:brelock/domain/entities/password.dart';
import 'package:uuid/uuid.dart';

class PasswordRepository {
  final PasswordDatasource dataSource;
  final PasswordTranslator passwordTranslator;

  PasswordRepository({
    required this.dataSource,
    required this.passwordTranslator
  });

  Future<List<Password>> getAll(UuidValue consumerId) async {
    final data = await dataSource.getAll(consumerId.toString());
    List<Password> results = [];
    data.forEach((password) {
      results.add(passwordTranslator.toEntity(password));
    });
    return results;
  }

  Future<Password> get(UuidValue id) async {
    final data = await dataSource.get(id.toString());
    return passwordTranslator.toEntity(data);
  }

  Future<void> create(Password password) async {
    final model = passwordTranslator.toDocument(password);
    await dataSource.create(model);
  }

  Future<void> update(Password password) async {
    final model = passwordTranslator.toDocument(password);
    await dataSource.update(password.id.toString(), model);
  }

  Future<void> delete(UuidValue id) async {
    await dataSource.delete(id.toString());
  }

  Future<void> toggleFavourite(UuidValue passwordId, bool isFavourite) async {
    await dataSource.update(passwordId.toString(), {'is_favourite': isFavourite});
  }
}