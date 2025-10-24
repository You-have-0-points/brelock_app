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
  String? twoFactorSecret;
  bool twoFactorEnabled = false;
  DateTime? twoFactorEnabledAt;

  Consumer({
    required UuidValue id,
    required String email,
    required String password,
    required ConsumerSetting setting,
    required DateTime createdAt,
    required DateTime loggedAt,
    required List<UuidValue> folderIds,
    String? twoFactorSecret,
    bool twoFactorEnabled = false,
    DateTime? twoFactorEnabledAt
  }){
    this.id = id;
    this.email = email;
    this.password = password;
    this.setting = setting;
    this.createdAt = createdAt;
    this.loggedAt = loggedAt;
    this.folderIds = folderIds;
    this.twoFactorSecret = twoFactorSecret;
    this.twoFactorEnabled = twoFactorEnabled;
    this.twoFactorEnabledAt = twoFactorEnabledAt;
  }

  Consumer.base(String email, String password){
    this.id = UuidValue.fromString(Uuid().v4());
    this.email = email;
    this.password = password;
    this.createdAt = DateTime.now();
    this.loggedAt = DateTime.now();
    this.setting = ConsumerSetting.withTheme(Theme.LIGHT);
    this.folderIds = [];
    this.twoFactorSecret = null;
    this.twoFactorEnabled = false;
    this.twoFactorEnabledAt = null;
  }

  Consumer.empty(){
    twoFactorEnabled = false;
    twoFactorSecret = null;
    twoFactorEnabledAt = null;
  }

  void copy(Consumer consumer){
    this.id = consumer.id;
    this.email = consumer.email;
    this.password = consumer.password;
    this.setting = consumer.setting;
    this.createdAt = consumer.createdAt;
    this.loggedAt = consumer.loggedAt;
    this.folderIds = consumer.folderIds;
    this.twoFactorSecret = consumer.twoFactorSecret;
    this.twoFactorEnabled = consumer.twoFactorEnabled;
    this.twoFactorEnabledAt = consumer.twoFactorEnabledAt;
  }

  void update(Consumer consumer_update){
    this.email = consumer_update.email;
    this.password = consumer_update.password;
    this.setting = consumer_update.setting;
    this.folderIds = consumer_update.folderIds;
    this.twoFactorSecret = consumer_update.twoFactorSecret;
    this.twoFactorEnabled = consumer_update.twoFactorEnabled;
    this.twoFactorEnabledAt = consumer_update.twoFactorEnabledAt;
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

  void updateTwoFactorAuth(String? secret, bool enabled) {
    this.twoFactorSecret = secret;
    this.twoFactorEnabled = enabled;
    this.twoFactorEnabledAt = enabled ? DateTime.now() : null;
  }
}