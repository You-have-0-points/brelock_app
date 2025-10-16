import 'package:brelock/domain/enums/themes.dart';
import 'package:flutter/animation.dart';
import 'package:uuid/uuid.dart';
import 'consumer_setting.dart';

class Consumer{
  UuidValue? id;
  String? email;
  String? password;
  DateTime? createdAt;
  DateTime? loggedAt;
  ConsumerSetting? setting;
  List<UuidValue>? folderIds;

  Consumer({
      required UuidValue id,
      required String email,
      required String password,
      required ConsumerSetting setting,
      required DateTime createdAt,
      required DateTime loggedAt,
      required List<UuidValue> folderIds
  }){
    this.id = id;
    this.email = email;
    this.password = password;
    this.setting = setting;
    this.createdAt = createdAt;
    this.loggedAt = loggedAt;
    this.folderIds = folderIds;
  }

  Consumer.base(String email, String password){
    this.id = UuidValue.fromString(Uuid().v4());
    this.email = email;
    this.password = password;
    this.createdAt = DateTime.now();
    this.loggedAt = DateTime.now();
    this.setting = ConsumerSetting.withTheme(Theme.LIGHT);
    this.folderIds = [];
  }

  Consumer.empty();

  void copy(Consumer consumer){
    this.id = consumer.id;
    this.email = consumer.email;
    this.password = consumer.password;
    this.setting = consumer.setting;
    this.createdAt = consumer.createdAt;
    this.loggedAt = consumer.loggedAt;
    this.folderIds = consumer.folderIds;
  }

  void update(Consumer consumer_update){
    this.email = consumer_update.email;
    this.password = consumer_update.password;
    this.setting = consumer_update.setting;
    this.folderIds = consumer_update.folderIds;
  }

  void updateEmail(String email){
    this.email = email;
  }

  void updatePassword(String password){
    this.password = password;
  }

  void addFolder(UuidValue id){
    this.folderIds!.add(id);
  }

  void deleteFolder(UuidValue id){
    this.folderIds!.remove(id);
  }
}