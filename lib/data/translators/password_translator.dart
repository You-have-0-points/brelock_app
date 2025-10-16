import 'package:brelock/domain/entities/password.dart';
import 'package:uuid/uuid.dart';
import 'package:brelock/data/translators/service_translator.dart';

class PasswordTranslator{
  ServiceTranslator serviceTranslator;

  PasswordTranslator(this.serviceTranslator);

  Map<String, dynamic> toDocument(Password password){
    return {
      "id": password.id.uuid,
      "service": serviceTranslator.toDocument(password.serviceName),
      "login": password.login,
      "password": password.secret,
      "is_favourite": password.isFavourite.toString(),
      "created_at": password.createdAt.toIso8601String(),
      "updated_at": password.updatedAt!.toIso8601String(),
      "user_id": password.userId.uuid
    };
  }

  Password toEntity(Map<String, dynamic> passwordData){
    return Password(
        id: UuidValue.fromString(passwordData["id"]!),
        serviceName: serviceTranslator.toEntity(passwordData["service"]!),
        login: passwordData["login"]!,
        secret: passwordData["password"]!,
        isFavourite: passwordData["is_favourite"] == "true",
        createdAt: DateTime.parse(passwordData["created_at"]!),
        updatedAt: DateTime.parse(passwordData["updated_at"]!),
        userId: UuidValue.fromString(passwordData["user_id"]!)
    );
  }
}