import 'package:brelock/presentation/features/login/widgets/pin_code_field.dart';
import 'package:brelock/presentation/features/password_list/screens/password_list_screen.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';

class LoginTwoFactorAuthScreen extends StatefulWidget {
  const LoginTwoFactorAuthScreen({super.key});

  @override
  State<LoginTwoFactorAuthScreen> createState() => _LoginTwoFactorAuthScreenState();
}

class _LoginTwoFactorAuthScreenState extends State<LoginTwoFactorAuthScreen> {

  final String code = "657890";

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Sizes.spacingMd),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: Sizes.spacingMd),
                child: PinCodeField(length: 6, onCompleted: (code) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n!.loginSuccess)));
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordListScreen()));
                } ),
              )
            ],
          ),
        ),
      ),
    );
  }
}