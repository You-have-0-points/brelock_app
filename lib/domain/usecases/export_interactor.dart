import 'dart:convert';

import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/domain/usecases/password_interactor.dart';
import 'package:brelock/domain/entities/folder.dart';
import 'package:brelock/domain/usecases/folder_interactor.dart';
import 'package:uuid/uuid.dart';
import 'package:brelock/di_injector.dart';

import '../entities/consumer.dart';

class ExportInteractor {
  final PasswordInteractor passwordInteractor;
  final FolderInteractor folderInteractor;

  ExportInteractor({
    required this.passwordInteractor,
    required this.folderInteractor,
  });

  Future<String> exportToJson(UuidValue consumerId) async {
    try {
      final folders = await folderInteractor.getAll(await _getConsumerById(consumerId));
      final allPasswords = <Password>[];

      // Собираем все пароли из всех папок
      for (final folder in folders) {
        final folderPasswords = await passwordInteractor.getByIds(folder.passwordsIds);
        allPasswords.addAll(folderPasswords);
      }

      // Убираем дубликаты по ID
      final uniquePasswords = allPasswords.toSet().toList();

      // Формируем структуру для экспорта
      final exportData = {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'passwords': uniquePasswords.map((password) => _passwordToMap(password)).toList(),
      };

      return _formatJson(exportData);
    } catch (e) {
      throw Exception('Ошибка экспорта: $e');
    }
  }

  Future<String> exportToCsv(UuidValue consumerId) async {
    try {
      final folders = await folderInteractor.getAll(await _getConsumerById(consumerId));
      final allPasswords = <Password>[];

      for (final folder in folders) {
        final folderPasswords = await passwordInteractor.getByIds(folder.passwordsIds);
        allPasswords.addAll(folderPasswords);
      }

      final uniquePasswords = allPasswords.toSet().toList();

      // Заголовки CSV
      final csvBuffer = StringBuffer()
        ..writeln('Название сервиса,URL,Логин,Пароль,Папка,Избранное,Дата создания');

      // Данные
      for (final password in uniquePasswords) {
        final folderName = await _getFolderNameForPassword(password, folders);
        csvBuffer.writeln([
          _escapeCsvField(password.serviceName.name),
          _escapeCsvField(password.serviceName.url),
          _escapeCsvField(password.login),
          _escapeCsvField(password.secret),
          _escapeCsvField(folderName),
          password.isFavourite ? 'Да' : 'Нет',
          password.createdAt.toIso8601String(),
        ].join(','));
      }

      return csvBuffer.toString();
    } catch (e) {
      throw Exception('Ошибка экспорта в CSV: $e');
    }
  }

  Map<String, dynamic> _passwordToMap(Password password) {
    return {
      'id': password.id.uuid,
      'service': {
        'name': password.serviceName.name,
        'url': password.serviceName.url,
      },
      'login': password.login,
      'password': password.secret,
      'is_favourite': password.isFavourite,
      'created_at': password.createdAt.toIso8601String(),
      'updated_at': password.updatedAt?.toIso8601String(),
    };
  }

  String _formatJson(Map<String, dynamic> data) {
    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  Future<String> _getFolderNameForPassword(Password password, List<Folder> folders) async {
    for (final folder in folders) {
      if (folder.passwordsIds.contains(password.id)) {
        return folder.name;
      }
    }
    return 'Общее';
  }

  Future<Consumer> _getConsumerById(UuidValue id) async {
    // Здесь нужно получить consumer по ID
    // Временно возвращаем current_consumer
    return current_consumer;
  }
}