import 'package:brelock/core/errors/InvalidRequestException.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class Service {
  final UuidValue id;
  final String iconUrl; //Its for future
  final String name;
  final String url;

  Service._(this.id, this.name, this.url):
        iconUrl = "";

  factory Service(String name, String url , UuidValue? id, {String iconUrl = ""}) {
    if (id == null){
      id = UuidValue.fromString(Uuid().v4());
    }
    final trimmedValue = name.trim();
    if (trimmedValue.isEmpty) throw InvalidRequestException("Service name is empty.");
    if (trimmedValue.length > 100) throw InvalidRequestException("Service name is too long");
    return Service._(id, trimmedValue, url);
  }

  @override
  String toString() => 'ServiceName(value: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Service && name == other.name);

  @override
  int get hashCode => name.hashCode;
}