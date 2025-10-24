import 'package:brelock/data/data_sources/consumer_datasource.dart';
import 'package:brelock/data/translators/consumer_setting_translator.dart';
import 'package:brelock/data/translators/consumer_translator.dart';
import 'package:brelock/domain/entities/consumer.dart';
import 'package:uuid/uuid.dart';

class ConsumerRepository {
  final ConsumerDatasource dataSource;
  final ConsumerTranslator translator;
  final ConsumerSettingsTranslator settingsTranslator;

  ConsumerRepository({
    required this.dataSource,
    required this.translator,
    required this.settingsTranslator
  });

  //TODO: what if datasource and repo dont throw exceptions but smth like service do?

  Future<void> create(Consumer consumer) async{
    await dataSource.create(translator.toDocument(consumer));
  }

  Future<Consumer?> getByLoginData(String email, String password) async{
    final data = await dataSource.getByLoginData(email, password);
    return translator.toEntity(data);
  }

  Future<Consumer> getById(Uuid id) async{
    final data = await dataSource.getById(id.toString());
    return translator.toEntity(data);
  }

  Future<Consumer> getByIdString(String id) async{
    final data = await dataSource.getById(id);
    return translator.toEntity(data);
  }

  Future<Consumer> getByEmail(String email) async {
    final data = await dataSource.getByEmail(email);
    return translator.toEntity(data);
  }

  Future<void> update(Consumer consumer) async{
    await dataSource.update(consumer.id.toString(), translator.toDocument(consumer));
  }

  Future<void> delete(UuidValue id) async{
    await dataSource.delete(id.toString());
  }
}