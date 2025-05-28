import 'package:brelock/themes/sizes.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData get lightTheme {
    final colorSchemeLight = ColorScheme.light(
      primary: const Color(0xff495d92),
      onPrimary: const Color(0xffffffff),
      error: const Color(0xffba1a1a),
      outline: const Color(0xff9099a0),
      outlineVariant: const Color(0xffEEEFF3),
      shadow: const Color(0xff000000),
      onBackground: const Color(0xff000000)
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeLight,
      scaffoldBackgroundColor: const Color(0xffeff1f3),
      //Тема текстовых полей
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorSchemeLight
              .primary, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorSchemeLight
                .outline,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIconColor: colorSchemeLight.outline.withOpacity(0.5),
        hintStyle: TextStyle(
          fontSize: Sizes.fontSizeMedium,
          color: colorSchemeLight
              .outline
              .withOpacity(0.7),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56)),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black.withOpacity(0.15);
                }
                return null;
              }
          ),
          backgroundColor: MaterialStateProperty.all(colorSchemeLight
              .primary),
          foregroundColor: WidgetStatePropertyAll(colorSchemeLight
              .onPrimary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.buttonRadius), // Радиус закругления
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56)),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                if (states.contains(MaterialState.pressed)) {
                  return colorSchemeLight.error.withOpacity(0.15);
                }
                return null;
              }
          ),
          foregroundColor: WidgetStatePropertyAll(colorSchemeLight
              .error),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.buttonRadius), // Радиус закругления
            ),
          ),
          side: WidgetStatePropertyAll(BorderSide(color: colorSchemeLight.error, width: 0.7))
        ),
      ),
    );
  }
  static ThemeData get darkTheme {
    final colorSchemeDark = ColorScheme.dark(
      primary: const Color(0xff495d92),
      onPrimary: const Color(0xffffffff),
      error: const Color(0xffba1a1a),
      outline: const Color(0xff9099a0),
      outlineVariant: const Color(0xffEEEFF3),
      shadow: const Color(0xff000000),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorSchemeDark,
      scaffoldBackgroundColor: const Color(0xff252525),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorSchemeDark
              .primary, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorSchemeDark
                .outline,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIconColor: colorSchemeDark.outline.withOpacity(0.5),
        hintStyle: TextStyle(
          fontSize: Sizes.fontSizeMedium,
          color: colorSchemeDark
              .outline
              .withOpacity(0.7),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56)),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black.withOpacity(0.15);
                }
                return null;
              }
          ),
          backgroundColor: MaterialStateProperty.all(colorSchemeDark
              .primary),
          foregroundColor: WidgetStatePropertyAll(colorSchemeDark
              .onPrimary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Sizes.buttonRadius), // Радиус закругления
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56)),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                  if (states.contains(MaterialState.pressed)) {
                    return colorSchemeDark.error.withOpacity(0.15);
                  }
                  return null;
                }
            ),
            foregroundColor: WidgetStatePropertyAll(colorSchemeDark
                .error),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.buttonRadius), // Радиус закругления
              ),
            ),
            side: WidgetStatePropertyAll(BorderSide(color: colorSchemeDark.error, width: 0.7))
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 0.25
      )
    );
  }
}
