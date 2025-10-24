import 'dart:math';

import 'package:flutter/material.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';

import '../../../themes/sizes.dart';

class GeneratePasswordScreen extends StatefulWidget {
  const GeneratePasswordScreen({super.key});

  @override
  State<GeneratePasswordScreen> createState() => _GeneratePasswordScreenState();
}

class _GeneratePasswordScreenState extends State<GeneratePasswordScreen> {

  double _value = 16.0;
  bool _useLetters = true;
  bool _useDigits = true;
  bool _useSpecSymbols = true;
  String password = " ";

  void _generatePassword() {
    try {
      setState(() {
        password = generatePassword(
          length: _value.toInt(),
          useLetters: _useLetters,
          useDigits: _useDigits,
          useSpecial: _useSpecSymbols,
        );
      });
    } on ArgumentError catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка'),
          content: Text(e.message),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = ColorScheme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.buttonRadius))
        ),
        padding: EdgeInsets.all(Sizes.spacingMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Sizes.iconSizeLg,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                Text(l10n!.generation, style: TextStyle(fontSize: Sizes.fontSizeHeading)),
                IconButton(onPressed: () {
                  _generatePassword();
                }, icon: Icon(Icons.refresh_rounded, size: Sizes.iconSizeLg,))
              ],
            ),
            SizedBox(height: Sizes.spacingMd,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Sizes.spacingMd),
              margin: EdgeInsets.symmetric(horizontal: Sizes.spacingMd),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.buttonRadius),
                color: colorScheme.primary.withOpacity(0.1),
              ),
              child: Align(alignment: Alignment.center,
                  child: Text("$password", style: TextStyle(fontSize: Sizes.fontSizeHeading), textAlign: TextAlign.center,)),
            ),
            SizedBox(height: Sizes.spacingMd,),
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.length(_value.toInt().toString())),
                    SizedBox(
                      width: 250,
                      child: Slider(
                          inactiveColor: colorScheme.primary.withOpacity(0.2),
                          min: 16,
                          max: 32,
                          value: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                          }
                      ),
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.letters),
                    Switch(
                        value: _useLetters,
                        onChanged: (value) {
                          setState(() {
                            _useLetters = value;
                          });
                        }
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.digits),
                    Switch(
                        value: _useDigits,
                        onChanged: (value) {
                          setState(() {
                            _useDigits = value;
                          });
                        }
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.specialSymbols),
                    Switch(
                        value: _useSpecSymbols,
                        onChanged: (value) {
                          setState(() {
                            _useSpecSymbols = value;
                          });
                        }
                    )
                  ],
                ),
                Divider(),
                ElevatedButton(onPressed: () {
                  Navigator.pop(context, password);
                }, child: Text(l10n.apply))
              ],
            ),
            SizedBox(height: Sizes.spacingSm),
          ],
        ),
      ),
    );
  }

  String generatePassword({
    int length = 16,
    bool useLetters = true,
    bool useDigits = true,
    bool useSpecial = true,
  }) {
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const digits = '0123456789';
    const special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String availableChars = '';
    if (useLetters) availableChars += letters;
    if (useDigits) availableChars += digits;
    if (useSpecial) availableChars += special;

    if (availableChars.isEmpty) {
      throw ArgumentError('Хотя бы один тип символов должен быть включен');
    }

    final random = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        length,
            (_) => availableChars.codeUnitAt(
          random.nextInt(availableChars.length),
        ),
      ),
    );
  }
}