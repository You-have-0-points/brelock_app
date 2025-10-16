import 'package:brelock/presentation/features/security_settings/screens/security_settings_screen.dart';
import 'package:brelock/presentation/features/settings_two_factor_auth/screens/two_factor_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:brelock/di_injector.dart';
import 'package:brelock/presentation/features/change_master_password/change_master_password.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:brelock/presentation/language_provider.dart';

import '../../../themes/sizes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                  child: Text((languageProvider.currentLanguage == 'English' ? "English" : "Русский"), style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: Sizes.fontSizeSmall),),
                  onTap:
                      () {
                    languageProvider.toggleLanguage();
                  }
                ),
              ),

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
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeMasterPasswordScreen(email: current_consumer.email!)));
                },
                child: Text(l10n.changeMasterPassword),
              )
            ],
          ),
        ),
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
}