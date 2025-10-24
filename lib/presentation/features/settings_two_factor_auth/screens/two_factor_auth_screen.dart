import 'package:brelock/di_injector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clipboard/clipboard.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';
import 'package:brelock/presentation/features/settings/settings_screen/settings_screen.dart';

import '../../../themes/sizes.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  final TextEditingController _verificationCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  void _connectTwoFactorAuth() {
    if (_formKey.currentState!.validate()) {
      // Если поле заполнено корректно
      current_consumer.twoFactorEnabled = true;
      current_consumer.twoFactorEnabledAt = DateTime.now();
      current_consumer.twoFactorSecret = "ABJDKPRBJDKLD";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.success)),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
    }
  }

  String? _validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterVerificationCode;
    }
    if (value.length != 6) {
      return AppLocalizations.of(context)!.verificationCodeMustBe6Digits;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = ColorScheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.twoFactorAuth),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: EdgeInsets.fromLTRB(
                Sizes.spacingMd,
                0,
                Sizes.spacingMd,
                Sizes.spacingMd,
              ),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(l10n.connection, style: TextStyle(fontSize: Sizes.fontSizeLarge,), textAlign: TextAlign.center,),
                      SizedBox(height: Sizes.spacingXl,),
                      Text(l10n.scanQRCode, textAlign: TextAlign.center,),
                      SizedBox(height: Sizes.spacingMd,),
                      QrImageView(
                        data: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&pp=ygUM0YDQuNC60YDQvtC7",
                        version: QrVersions.auto,
                        size: 300,
                      ),
                      SizedBox(height: Sizes.spacingXl,),
                      Text(l10n.cantScan, textAlign: TextAlign.start, style: TextStyle(fontSize: Sizes.fontSizeSmall),),
                      SizedBox(height: Sizes.spacingMd,),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: RichText(text: TextSpan(
                            style: TextStyle(color: colorScheme.onBackground),
                            children: [
                              TextSpan(text: "Скопируйте "),
                              TextSpan(
                                  text: l10n.copySecretKey,
                                  style: TextStyle(color: colorScheme.primary,),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    showDialog(context: context, builder: (context) => AlertDialog(
                                      title: Text(l10n.your2FASecret, style: TextStyle(fontSize: Sizes.fontSizeHeading),),
                                      content: Container(
                                        child: Text("ABJDKPRBJDKLD", style: TextStyle(fontSize: Sizes.fontSizeMedium),),
                                      ),
                                      actions: [
                                        IconButton(onPressed: () {
                                          FlutterClipboard.copy('ABJDKPRBJDKLD').then(( value ) => print('copied'));
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.copy))
                                      ],
                                    )
                                    );
                                  }
                              ),
                              TextSpan(
                                text: l10n.andCompleteSetup,
                              )
                            ]
                        )),
                      ),
                      SizedBox(height: Sizes.spacingMd,),
                      Align(alignment: AlignmentDirectional.centerStart,
                        child: Text(l10n.enterVerificationCode),
                      ),
                      SizedBox(height: Sizes.spacingSm,),
                      TextFormField(
                        controller: _verificationCodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: "XXXXXX",
                          errorText: null, // Убираем дублирование ошибки
                        ),
                        validator: _validateVerificationCode,
                      ),
                      ElevatedButton(
                        onPressed: _connectTwoFactorAuth,
                        child: Text(l10n.connect),
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.green)
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}