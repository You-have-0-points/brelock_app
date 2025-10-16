import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clipboard/clipboard.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';

import '../../../themes/sizes.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
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
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                          hintText: "XXXXXX"
                      ),
                    ),
                    ElevatedButton(onPressed: () {},
                      child: Text(l10n.connect),
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.green)
                      ),
                    )
                  ],
                ),
              )
          ),
        ),
      ),
    );;
  }
}