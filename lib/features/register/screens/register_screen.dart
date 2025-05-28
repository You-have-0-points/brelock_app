import 'package:flutter/material.dart';

import '../../../themes/sizes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                padding: EdgeInsets.fromLTRB(Sizes.spacingMd, 0, Sizes.spacingMd, Sizes.spacingMd),
                child: Form(
                  child: Column(
                    children: [
                      Text("Регистрация", style: TextStyle(fontSize: Sizes.fontSizeHeading),),
                      SizedBox(height: Sizes.spacingMd,),
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
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password_rounded),
                          hintText: "Повторите мастер-пароль",
                        ),
                      ),
                      SizedBox(height: Sizes.spacingMd),
                      ElevatedButton(
                          onPressed:() {},
                          child: Text("Зарегистрироваться")
                      ),
                      SizedBox(height: Sizes.spacingMd),
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
                'Регистрируясь, вы соглашаетесь с',
                style: TextStyle(color: Colors.grey),
              ),
              GestureDetector(
                child: Text(
                  'Политикой конфиденциальности',
                  style: TextStyle(color: ColorScheme.of(context).primary),
                ),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Политика конфиденциальности"))),
              )
            ],
          )
      ),

    );
  }
}
