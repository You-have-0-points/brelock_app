import 'package:brelock/domain/value_objects/service.dart';
import 'package:uuid/uuid.dart';

class Password{
  late UuidValue id;
  late Service serviceName;
  late String login;
  late String secret;
  late bool isFavourite;
  late DateTime createdAt;
  late DateTime? updatedAt;
  late UuidValue userId;

  Password({
    required UuidValue id,
    required Service serviceName,
    required String login,
    required String secret,
    required bool isFavourite,
    required DateTime createdAt,
    required DateTime updatedAt,
    required UuidValue userId
  }){
    this.id = id;
    this.serviceName = serviceName;
    this.login = login;
    this.secret = secret;
    this.isFavourite = isFavourite;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.userId = userId;
  }


  void update(Service service, String login, String secret, bool isFavourite){
    this.serviceName = service;
    this.login = login;
    this.secret = secret;
    this.isFavourite = isFavourite;
  }

  void updateIsFavourite(bool flag){
    this.isFavourite = flag;
  }
}