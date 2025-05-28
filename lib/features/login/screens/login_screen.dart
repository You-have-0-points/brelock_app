import 'package:brelock/features/login/screens/login_two_factor_auth_screen.dart';
import 'package:brelock/features/password_list/screens/password_list_screen.dart';
import 'package:brelock/features/register/screens/register_screen.dart';
import 'package:brelock/themes/sizes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 56),
            Center(
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Sizes.spacingMd,
                  0,
                  Sizes.spacingMd,
                  Sizes.spacingMd,
                ),
                child: Form(
                  child: Column(
                    children: [
                      Text(
                        "Вход",
                        style: TextStyle(fontSize: Sizes.fontSizeHeading),
                      ),
                      SizedBox(height: Sizes.spacingMd),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                          hintText: "Email-адрес",
                        ),
                      ),
                      SizedBox(height: Sizes.spacingSm),
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password_rounded),
                          hintText: "Мастер-пароль",
                        ),
                      ),
                      SizedBox(height: Sizes.spacingSm),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: GestureDetector(
                          child: Text(
                            'Забыли пароль?',
                            style: TextStyle(
                              color: ColorScheme.of(context).primary,
                            ),
                          ),
                          onTap:
                              () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Тапнуто")),
                              ),
                        ),
                      ),
                      SizedBox(height: Sizes.spacingMd),
                      ElevatedButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginTwoFactorAuthScreen()));
                      }, child: Text("Войти")),
                      SizedBox(height: Sizes.spacingMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Нет аккаунта?',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(width: Sizes.spacingXs),
                              GestureDetector(
                                child: Text(
                                  'Регистрация',
                                  style: TextStyle(
                                    color: ColorScheme.of(context).primary,
                                  ),
                                ),
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterScreen(),
                                      ),
                                    ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Входя, вы соглашаетесь с',
              style: TextStyle(color: Colors.grey),
            ),
            GestureDetector(
              child: Text(
                'Политикой конфиденциальности',
                style: TextStyle(color: ColorScheme.of(context).primary),
              ),
              onTap:
                  () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Тапнуто"))),
            ),
          ],
        ),
      ),
    );
  }
}
