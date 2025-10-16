import 'package:brelock/data/data_sources/folder_datasource.dart';
import 'package:brelock/data/translators/folder_translator.dart';
import 'package:brelock/domain/entities/consumer.dart';
import 'package:brelock/domain/entities/folder.dart';
import 'package:uuid/uuid.dart';

class FolderRepository {
  final FolderDatasource dataSource;
  final FolderTranslator folderTranslator;

  FolderRepository({
    required this.dataSource,
    required this.folderTranslator
  });

  Future<void> create(Folder folder) async {
    await dataSource.create(folderTranslator.toDocument(folder));
  }

  Future<List<Folder>> getAll(Consumer consumer) async {
    final data = await dataSource.getAll(consumer.folderIds!);
    final folders = data.map((folderData) => folderTranslator.toEntity(folderData)).toList();

    folders.sort((a, b) {
      if (a.name == "Общее") return -1;
      if (b.name == "Общее") return 1;

      if (a.name == "Избранное") return -1;
      if (b.name == "Избранное") return 1;

      return b.createdAt.compareTo(a.createdAt);
    });

    return folders;
  }

  Future<Folder> getById(UuidValue id) async {
    final data = await dataSource.get(id.toString());
    return folderTranslator.toEntity(data);
  }

  Future<Folder?> getByName(String name, Consumer consumer) async {
    if (consumer.folderIds == null || consumer.folderIds!.isEmpty) {
      return null;
    }
    final futures = consumer.folderIds!.map((folderId) => getById(folderId));
    final folders = await Future.wait(futures);
    try {
      return folders.firstWhere((folder) => folder.name == name);
    } catch (e) {
      return null; //TODO: think about errors again
    }
  }

  Future<void> update(Folder folder) async {;
    await dataSource.update(folder.id.toString(), folderTranslator.toDocument(folder));
  }

  Future<void> delete(String id) async {
    await dataSource.delete(id);
  }
}