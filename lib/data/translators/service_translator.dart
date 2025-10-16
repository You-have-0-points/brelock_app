import 'package:brelock/domain/value_objects/service.dart';
import 'package:uuid/uuid.dart';

class ServiceTranslator{
  Map<String, String> toDocument(Service service){
    return {
      "id": service.id.uuid,
      "name": service.name,
      "url": service.url
    };
  }

  Service toEntity(Map<String, dynamic> serviceData){
    return Service(serviceData["name"]!, serviceData["url"], UuidValue.fromString(serviceData["id"]));
  }
}