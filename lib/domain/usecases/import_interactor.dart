import 'dart:convert';

import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/domain/usecases/password_interactor.dart';
import 'package:brelock/domain/usecases/folder_interactor.dart';
import 'package:brelock/domain/entities/consumer.dart';
import 'package:brelock/domain/value_objects/service.dart';
import 'package:uuid/uuid.dart';

class ImportInteractor {
  final PasswordInteractor passwordInteractor;
  final FolderInteractor folderInteractor;

  ImportInteractor({
    required this.passwordInteractor,
    required this.folderInteractor,
  });

  Future<int> importFromJson(String jsonData, UuidValue consumerId) async {
    try {
      final Map<String, dynamic> data = json.decode(jsonData);
      final List<dynamic> passwordsData = data['passwords'] ?? [];

      int importedCount = 0;

      for (final passwordData in passwordsData) {
        try {
          final password = _mapToPassword(passwordData, consumerId);
          await passwordInteractor.create(
            password.serviceName.url,
            password.login,
            password.secret,
            password.serviceName.name,
            consumerId,
          );
          importedCount++;
        } catch (e) {
          print('Ошибка импорта пароля: $e');
        }
      }

      return importedCount;
    } catch (e) {
      throw Exception('Ошибка импорта JSON: $e');
    }
  }

  Future<int> importFromCsv(String csvData, UuidValue consumerId) async {
    try {
      final lines = csvData.split('\n');
      if (lines.isEmpty) return 0;

      // Пропускаем заголовок
      final dataLines = lines.skip(1).where((line) => line.trim().isNotEmpty);
      int importedCount = 0;

      for (final line in dataLines) {
        try {
          final fields = _parseCsvLine(line);
          if (fields.length >= 4) {
            final serviceName = fields[0];
            final url = fields[1];
            final login = fields[2];
            final password = fields[3];
            final folderName = fields.length > 4 ? fields[4] : 'Общее';

            if (serviceName.isNotEmpty && password.isNotEmpty) {
              await passwordInteractor.create(
                url,
                login,
                password,
                serviceName,
                consumerId,
              );
              importedCount++;
            }
          }
        } catch (e) {
          print('Ошибка импорта строки CSV: $e');
        }
      }

      return importedCount;
    } catch (e) {
      throw Exception('Ошибка импорта CSV: $e');
    }
  }

  Password _mapToPassword(Map<String, dynamic> data, UuidValue consumerId) {
    final serviceData = data['service'] as Map<String, dynamic>? ?? {};

    return Password(
      id: UuidValue.fromString(Uuid().v4()), // Новый ID при импорте
      serviceName: Service(
        serviceData['name'] ?? '',
        serviceData['url'] ?? '',
        null,
      ),
      login: data['login'] ?? '',
      secret: data['password'] ?? '',
      isFavourite: data['is_favourite'] ?? false,
      createdAt: DateTime.parse(data['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(data['updated_at'] ?? DateTime.now().toIso8601String()),
      userId: consumerId,
    );
  }

  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    StringBuffer currentField = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          // Экранированная кавычка
          currentField.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(currentField.toString());
        currentField.clear();
      } else {
        currentField.write(char);
      }
    }

    result.add(currentField.toString());
    return result;
  }
}