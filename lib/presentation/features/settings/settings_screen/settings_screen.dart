import 'dart:io';
import 'dart:convert';
import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/consumer.dart';
import 'package:brelock/presentation/features/security_settings/screens/security_settings_screen.dart';
import 'package:brelock/presentation/features/settings_two_factor_auth/screens/two_factor_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:brelock/presentation/features/change_master_password/change_master_password.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:brelock/presentation/language_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../themes/sizes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isExporting = false;
  bool _isImporting = false;

  Future<void> _exportPasswords() async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      _isExporting = true;
    });

    try {
      // Показать диалог выбора формата
      final format = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n!.chooseExportFormat),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('JSON'),
                subtitle: Text(l10n.jsonFormatDescription),
                leading: Icon(Icons.code),
                onTap: () => Navigator.pop(context, 'json'),
              ),
              ListTile(
                title: Text('CSV'),
                subtitle: Text(l10n.csvFormatDescription),
                leading: Icon(Icons.table_chart),
                onTap: () => Navigator.pop(context, 'csv'),
              ),
            ],
          ),
        ),
      );

      if (format != null) {
        String exportData;
        String fileExtension;
        String mimeType;

        if (format == 'json') {
          exportData = await exportInteractor.exportToJson(current_consumer.id!);
          fileExtension = 'json';
          mimeType = 'application/json';
        } else {
          exportData = await exportInteractor.exportToCsv(current_consumer.id!);
          fileExtension = 'csv';
          mimeType = 'text/csv';
        }

        // Сохраняем во временный файл
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final file = File('${directory.path}/brelock_passwords_$timestamp.$fileExtension');
        await file.writeAsString(exportData);

        // Делимся файлом
        await Share.shareXFiles(
            [XFile(file.path, mimeType: mimeType)]
        );

        if (!mounted) return;
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n!.exportError}: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  Future<void> _importPasswords() async {
    final l10n = AppLocalizations.of(context);

    setState(() {
      _isImporting = true;
    });

    try {
      // Выбор файла
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileContent = await file.readAsString();
        final fileName = result.files.single.name.toLowerCase();

        int importedCount;

        if (fileName.endsWith('.json')) {
          importedCount = await importInteractor.importFromJson(fileContent, current_consumer.id!);
        } else if (fileName.endsWith('.csv')) {
          importedCount = await importInteractor.importFromCsv(fileContent, current_consumer.id!);
        } else {
          throw Exception(l10n!.unsupportedFileFormat);
        }

        if (!mounted) return;

        // Показать результат
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n!.importComplete),
            content: Text(l10n.importedCount(importedCount)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Обновить данные на экране паролей
                  Navigator.pop(context, true);
                },
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n!.importError}: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  Future<void> _showImportConfirmation() async {
    final l10n = AppLocalizations.of(context);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n!.importPasswords),
        content: Text(l10n.importConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _importPasswords();
            },
            child: Text(l10n.import),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n!.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Русский'),
              leading: Radio(
                value: 'ru',
                groupValue: languageProvider.currentLanguageCode,
                onChanged: (value) {
                  languageProvider.setLocale(const Locale('ru'));
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text('English'),
              leading: Radio(
                value: 'en',
                groupValue: languageProvider.currentLanguageCode,
                onChanged: (value) {
                  languageProvider.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _truncateEmail(String email) {
    if (email.length <= 20) {
      return email;
    }
    return '${email.substring(0, 20)}...';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final colorScheme = ColorScheme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(l10n!.settings),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Sizes.spacingMd),
          child: Column(
            children: [
              // Язык с переключателем
              ListTile(
                leading: Icon(Icons.language_outlined),
                title: Text(l10n.language),
                trailing: GestureDetector(
                    child: Text(
                      (languageProvider.currentLanguage == 'English' ? "English" : "Русский"),
                      style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: Sizes.fontSizeSmall
                      ),
                    ),
                    onTap: () {
                      languageProvider.toggleLanguage();
                    }
                ),
              ),

              Divider(),

              ListTile(
                leading: Icon(Icons.mail_outline_rounded),
                title: Text(l10n.email),
                trailing: Text(
                  _truncateEmail(current_consumer.email!),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: Sizes.fontSizeSmall,
                  ),
                ),
              ),

              Divider(),

              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text(l10n.twoFactorAuth),
                trailing: GestureDetector(
                    child: Text(
                      l10n.disabled,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: Sizes.fontSizeSmall,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TwoFactorAuthScreen()));
                    }
                ),
              ),

              Divider(),

              SizedBox(height: Sizes.spacingMd),

              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeMasterPasswordScreen(email: current_consumer.email!)));
                },
                child: Text(l10n.changeMasterPassword),
              ),

              SizedBox(height: Sizes.spacingLg),

              // Новые кнопки импорта/экспорта
              Card(
                child: Padding(
                  padding: EdgeInsets.all(Sizes.spacingMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dataManagement,
                        style: TextStyle(
                          fontSize: Sizes.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Sizes.spacingMd),

                      // Кнопка экспорта
                      ListTile(
                        leading: _isExporting
                            ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Icon(Icons.upload_file),
                        subtitle: Text(l10n.exportDescription),
                        onTap: _isExporting ? null : _exportPasswords,
                        trailing: Icon(Icons.chevron_right),
                      ),

                      Divider(),

                      // Кнопка импорта
                      ListTile(
                        leading: _isImporting
                            ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : Icon(Icons.download),
                        title: Text(l10n.importPasswords),
                        subtitle: Text(l10n.importDescription),
                        onTap: _isImporting ? null : _showImportConfirmation,
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: Sizes.spacingLg),
            ],
          ),
        ),
      ),
    );
  }
}