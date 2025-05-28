import 'package:brelock/features/security_settings/screens/security_settings_screen.dart';
import 'package:brelock/features/settings_two_factor_auth/screens/two_factor_auth_screen.dart';
import 'package:flutter/material.dart';

import '../../../themes/sizes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Настройки"),
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
              ListTile(
                leading: Icon(Icons.language_outlined),
                title: Text("Язык"),
                trailing: GestureDetector(
                  child: Text("Русский", style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: Sizes.fontSizeSmall),),
                  //Сюда надо будет передавать перменную с выбранным языком
                  onTap:
                      () =>
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                          SnackBar(content: Text("Тапнуто на язык"))),
                ),
              ),
              ListTile(
                leading: Icon(Icons.mail_outline_rounded),
                title: Text("Почта"),
                trailing: GestureDetector(
                  child: Text("example@gmail.com", style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: Sizes.fontSizeSmall),),
                  //Сюда надо будет передавать перменную с почтой юзера
                  onTap:
                      () =>
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                          SnackBar(content: Text("Тапнуто на почту"))),
                ),
              ),
              ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text("2fa"),
                trailing: GestureDetector(
                  child: Text("Отключено", style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: Sizes.fontSizeSmall),),
                  //Сюда надо будет передавать перменную с почтой юзера
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TwoFactorAuthScreen()));
                  }
                ),
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SecuritySettingsScreen()));
                  },
                  child: Text("Смнеить мастер-пароль"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
