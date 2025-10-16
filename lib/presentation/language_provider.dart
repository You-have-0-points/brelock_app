// lib/presentation/language_provider.dart
import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('ru');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'ru'
        ? const Locale('en')
        : const Locale('ru');
    notifyListeners();
  }

  String get currentLanguage {
    return _locale.languageCode == 'ru' ? 'Русский' : 'English';
  }

  String get currentLanguageCode {
    return _locale.languageCode;
  }
}