import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/presentation/features/generate_password/screens/generate_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:uuid/uuid.dart';

class AddPasswordScreen extends StatefulWidget {
  final UuidValue? selectedFolderId;

  AddPasswordScreen({
    super.key,
    this.selectedFolderId
  });

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _obscurePassword = true; // Для скрытия пароля

  void _showGeneratePasswordSheet(BuildContext context) async {
    final generatedPassword = await showModalBottomSheet<String>(
        context: context,
        builder: (context) => GeneratePasswordScreen(),
        isScrollControlled: true
    );
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
                    obscureText: _obscurePassword, // Скрытие текста
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password_rounded),
                      hintText: "Пароль",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
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
                  ElevatedButton(onPressed: () async {
                    if(_passwordController.text.trim().isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Введите пароль")),
                      );
                      return;
                    }
                    if(_titleController.text.trim().isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Введите название сервиса")),
                      );
                      return;
                    }
                    if(_loginController.text.trim().isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Введите логин")),
                      );
                      return;
                    }
                    if(_urlController.text.trim().isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Введите URL-адрес сервиса")),
                      );
                      return;
                    }

                    if((await folderInteractor.checkContainsService(_titleController.text.trim(), current_consumer))){
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Пароль с таким названием уже существует")),
                      );
                      return;
                    }

                    print("THIRD RULE OF FIGHT CLUB IS ${widget.selectedFolderId}");
                    Password password_raw = await passwordInteractor.create(
                        _urlController.text.trim(),
                        _loginController.text.trim(),
                        _passwordController.text.trim(),
                        _titleController.text.trim(),
                        widget.selectedFolderId!
                    );
                    await folderInteractor.addPasswordToFolderAndBase(widget.selectedFolderId!, password_raw);

                    Navigator.pop(context);
                  }, child: Text("Добавить")),
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