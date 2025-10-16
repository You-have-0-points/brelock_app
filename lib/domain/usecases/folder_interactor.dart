import 'package:brelock/data/repositories/folder_repository.dart';
import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/consumer.dart';
import 'package:brelock/domain/entities/password.dart';
import 'package:uuid/uuid.dart';

import '../entities/folder.dart';

class FolderInteractor{
  final FolderRepository folderRepository;

  FolderInteractor({
    required this.folderRepository
  });

  Future<UuidValue> create(String? name) async {
    final foldersToCreate = <Folder>[];
    final folderIds = <UuidValue>[];

    if (name == null) {
      final baseFolder = Folder(
        id: UuidValue.fromString(Uuid().v4()),
        name: "Общее",
        createdAt: DateTime.now(),
        passwordsIds: [],
      );

      final favoriteFolder = Folder(
        id: UuidValue.fromString(Uuid().v4()),
        name: "Избранное",
        createdAt: DateTime.now(),
        passwordsIds: [],
      );

      foldersToCreate.addAll([baseFolder, favoriteFolder]);
    } else {
      final folder = Folder(
        id: UuidValue.fromString(Uuid().v4()),
        name: name,
        createdAt: DateTime.now(),
        passwordsIds: [],
      );

      foldersToCreate.add(folder);
    }

    for (final folder in foldersToCreate) {
      await folderRepository.create(folder);
      current_consumer.addFolder(folder.id);
      folderIds.add(folder.id);
    }

    consumerRepository.update(current_consumer);

    return foldersToCreate.last.id;
  }

  Future<List<Folder>> getAll(Consumer consumer) async {
    return await folderRepository.getAll(consumer);
  }

  Future<Folder> getById(UuidValue folderId) async{
    return await folderRepository.getById(folderId);
  }

  Future<void> addPasswordToFolderAndBase(UuidValue folderId, Password password) async{
    Folder folder = await folderRepository.getById(folderId);
    Folder? base_folder = await folderRepository.getByName("Общее", current_consumer);
    if(base_folder != null){
      print("FOUTH RULE - BASE FOLDER IS noooooooooooooooooooot NULL");
      base_folder.passwordsIds.add(password.id);
      await folderRepository.update(base_folder);
    }else{
      print("FOUTH RULE - BASE FOLDER IS NULL");
    }
    folder.passwordsIds.add(password.id);
    await folderRepository.update(folder);
  }

  Future<void> addPasswordToFolder(UuidValue folderId, Password password) async{
    Folder folder = await folderRepository.getById(folderId);
    folder.passwordsIds.add(password.id);
    await folderRepository.update(folder);
  }

  Future<void> deletePasswordFromFolder(UuidValue folderId, Password password) async{
    Folder folder = await folderRepository.getById(folderId);
    folder.passwordsIds.remove(password.id);
    folderRepository.update(folder);
  }

  Future<void> deletePassword(Consumer consumer, Password password) async{
    final List<Folder> folders = await getAll(consumer);

    final List<Folder> foldersWithPassword = folders.where((folder) {
      return folder.passwordsIds.contains(password.id);
    }).toList();

    for (final Folder folder in foldersWithPassword) {
      folder.passwordsIds.remove(password.id);
      await folderRepository.update(folder);
    }
  }

  Future<bool> checkContainsService(String nameService, Consumer consumer) async {
    try {
      Folder? base = await folderRepository.getByName("Общее", consumer);
      if (base == null) return false;

      List<Password> passwords = await Future.wait(
          base.passwordsIds.map((passwordId) => passwordRepository.get(passwordId))
      );

      return passwords.any((password) => password.serviceName.name == nameService);

    } catch (e) {
      print('Error in checkService: $e');
      return false;
    }
  }

  Future<void> delete(Folder folder) async {
    await folderRepository.delete(folder.id.toString());
  }
}