import 'package:brelock/domain/entities/folder.dart';
import 'package:uuid/uuid_value.dart';

class FolderTranslator{
  Map<String, dynamic> toDocument(Folder folder){
    return {
      "id": folder.id.uuid,
      "name": folder.name,
      "created_at": folder.createdAt.toIso8601String(),
      "password_ids": _many_ids_to_document(folder.passwordsIds)
    };
  }

  Folder toEntity(Map<String, dynamic> folderData){
    return Folder(
        id: UuidValue.fromString(folderData["id"]!),
        name: folderData["name"]!,
        createdAt: DateTime.parse(folderData["created_at"]!),
        passwordsIds: _many_ids_to_entity(folderData["password_ids"])
    );
  }

  List<String> _many_ids_to_document(List<UuidValue> list){
    List<String> result = [];
    list.forEach((element){
      result.add(element.uuid);
    });
    return result;
  }

  List<UuidValue> _many_ids_to_entity(List<dynamic> list){
    List<UuidValue> result = [];
    list.forEach((element){
      result.add(UuidValue.fromString(element));
    });
    return result;
  }
}