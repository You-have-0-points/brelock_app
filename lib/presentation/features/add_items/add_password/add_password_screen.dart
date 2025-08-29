import 'package:brelock/presentation/features/generate_password/screens/generate_password_screen.dart';
import 'package:flutter/material.dart';

import 'package:brelock/presentation/themes/sizes.dart';

class AddPasswordScreen extends StatefulWidget {
  AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();


}

class _AddPasswordScreenState extends State<AddPasswordScreen> {

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  void _showGeneratePasswordSheet(BuildContext context) async {
    final generatedPassword = await showModalBottomSheet<String>(context: context, builder: (context) => GeneratePasswordScreen(), isScrollControlled: true);
    if(generatedPassword != null && generatedPassword.isNotEmpty) {
      setState(() {
        _passwordController.text = generatedPassword;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Новый пароль"),
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
            child: Form(
              child: Column(
                children: [
                  SizedBox(height: Sizes.spacingMd),
                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.link),
                      hintText: "URL",
                    ),
                  ),
                  SizedBox(height: Sizes.spacingSm),
                  TextFormField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      hintText: "Логин",
                    ),
                  ),
                  SizedBox(height: Sizes.spacingSm),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password_rounded),
                      hintText: "Пароль",
                    ),
                  ),
                  SizedBox(height: Sizes.spacingSm),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title_outlined),
                      hintText: "Название",
                    ),
                  ),
                  SizedBox(height: Sizes.spacingMd),
                  OutlinedButton(
                    onPressed: () => _showGeneratePasswordSheet(context),
                    child: Text("Сгенерировать надёжный пароль"),
                    style: ButtonStyle(
                      side: WidgetStatePropertyAll(BorderSide(color: colorScheme.primary, width: 0.7)),
                      foregroundColor: WidgetStatePropertyAll(colorScheme.primary),
                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                              (states) {
                            if (states.contains(MaterialState.pressed)) {
                              return colorScheme.primary.withOpacity(0.15);
                            }
                            return null;
                          }
                      ),
                    ),
                  ),
                  SizedBox(height: Sizes.spacingSm),
                  ElevatedButton(onPressed: () {}, child: Text("Добавить")),
                  SizedBox(height: Sizes.spacingMd),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
