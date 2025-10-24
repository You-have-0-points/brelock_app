import 'package:uuid/uuid.dart';

class Folder{
  late UuidValue id;
  late String name;
  late DateTime createdAt;
  late List<UuidValue> passwordsIds;

  Folder({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.passwordsIds
  });

  void updateName(String newName){
    this.name = newName;
  }

  void addPassword(UuidValue id){
    this.passwordsIds.add(id);
  }

  void deletePassword(UuidValue id){
    this.passwordsIds.remove(id);
  }
}