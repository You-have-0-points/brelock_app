import 'package:brelock/presentation/features/login/screens/login_screen.dart';
import 'package:brelock/presentation/features/password_list/screens/password_list_screen.dart';
import 'package:brelock/presentation/features/settings/settings_screen/settings_screen.dart';
import 'package:brelock/presentation/themes/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.lightTheme, //здесь меняя darkTheme и lightTheme можно почекать темы, но чёт мне пока тёмная не оч нравится по цветам
      home: LoginScreen(),
    );
  }
}
