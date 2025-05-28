import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clipboard/clipboard.dart';

import '../../../themes/sizes.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("2fa"),
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
                  Text("Подключение", style: TextStyle(fontSize: Sizes.fontSizeLarge,), textAlign: TextAlign.center,),
                  SizedBox(height: Sizes.spacingXl,),
                  Text("Отскаинруйте QR-код с помощью приложения-аутентификатора", textAlign: TextAlign.center,),
                  SizedBox(height: Sizes.spacingMd,),
                  QrImageView(
                      data: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&pp=ygUM0YDQuNC60YDQvtC7",
                    version: QrVersions.auto,
                    size: 300,
                  ),
                  SizedBox(height: Sizes.spacingXl,),
                  Text("Не получается отсканировать?", textAlign: TextAlign.start, style: TextStyle(fontSize: Sizes.fontSizeSmall),),
                  SizedBox(height: Sizes.spacingMd,),
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: RichText(text: TextSpan(
                      style: TextStyle(color: colorScheme.onBackground),
                      children: [
                        TextSpan(text: "Скопируйте "),
                        TextSpan(
                          text: "секретный ключ ",
                          style: TextStyle(color: colorScheme.primary,),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            showDialog(context: context, builder: (context) => AlertDialog(
                              title: Text("Ваш 2fa секрет", style: TextStyle(fontSize: Sizes.fontSizeHeading),),
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
                          text: "и завершите настройку врчуную",
                        )
                      ]
                    )),
                  ),
                  SizedBox(height: Sizes.spacingMd,),
                  Align(alignment: AlignmentDirectional.centerStart,
                    child: Text("Вставьте код верификации из приложения"),
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
                      child: Text("Подключить"),
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
