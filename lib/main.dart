import 'package:brelock/presentation/features/login/screens/login_screen.dart';
import 'package:brelock/presentation/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brelock/presentation/theme_provider.dart';
import 'package:brelock/presentation/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';
import 'package:brelock/presentation/features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://krpfdkbuljduwnfmowrw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtycGZka2J1bGpkdXduZm1vd3J3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1Mjk1MzgsImV4cCI6MjA3MzEwNTUzOH0.MvSM6XWeocWc2vHHReQPTqDW5k3powOUJRAjJYzuajI',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            title: 'Brelock',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.themeMode,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru', ''),
              Locale('en', ''),
            ],
            locale: languageProvider.locale,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}