import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/consumer.dart';
import 'package:brelock/data/translators/consumer_setting_translator.dart';
import 'package:uuid/uuid.dart';

class ConsumerTranslator{
  ConsumerSettingsTranslator settingsTranslator;

  ConsumerTranslator(this.settingsTranslator);

  Map<String, dynamic> toDocument(Consumer consumer){
    return {
      "id": consumer.id!.uuid,
      "email": consumer.email,
      "password": consumer.password,
      "created_at": consumer.createdAt!.toIso8601String(),
      "logged_at": consumer.loggedAt!.toIso8601String(),
      "setting": settingsTranslator.toDocument(consumer.setting!),
      "folder_ids": _many_ids_to_document(consumer.folderIds!),
      "two_factor_secret": consumer.twoFactorSecret,
      "two_factor_enabled": consumer.twoFactorEnabled,
      "two_factor_enabled_at": consumer.twoFactorEnabledAt?.toIso8601String(),
    };
  }

  Consumer toEntity(Map<String, dynamic> consumerData){
    return Consumer(
      id: UuidValue.fromString(consumerData["id"]!),
      email: consumerData["email"]!,
      password: consumerData["password"]!,
      setting: settingsTranslator.toEntity(consumerData["setting"]!),
      createdAt: DateTime.parse(consumerData["created_at"]),
      loggedAt: DateTime.parse(consumerData["logged_at"]),
      folderIds: _many_ids_to_entity(consumerData["folder_ids"]!),
      twoFactorSecret: consumerData["two_factor_secret"],
      twoFactorEnabled: consumerData["two_factor_enabled"] ?? false,
      twoFactorEnabledAt: consumerData["two_factor_enabled_at"] != null
          ? DateTime.parse(consumerData["two_factor_enabled_at"])
          : null,
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