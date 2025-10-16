import 'package:brelock/di_injector.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';
import 'dart:async';

class ChangeMasterPasswordScreen extends StatefulWidget {
  final String email;

  const ChangeMasterPasswordScreen({super.key, required this.email});

  @override
  State<ChangeMasterPasswordScreen> createState() => _ChangeMasterPasswordScreenState();
}

class _ChangeMasterPasswordScreenState extends State<ChangeMasterPasswordScreen> {
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _codeSent = false;
  bool _codeVerified = false;
  bool _canResend = true;
  int _resendTimer = 0;
  String _generatedCode = '';
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  Timer? _timer;

  // Конфигурация SMTP серверов (такая же как в вашем работающем коде)
  final Map<String, Map<String, dynamic>> _smtpConfig = {
    'gmail.com': {
      'server': 'smtp.gmail.com',
      'port': 587,
      'username': 'brelock.app@gmail.com',
      'password': 'lwzr yduy fzab ifvp',
    },
    'ya.ru': {
      'server': 'smtp.yandex.ru',
      'port': 465,
      'ssl': true,
      'username': 'brelock.app@yandex.ru',
      'password': 'vohasjbqaiujeonm',
    },
    'yandex.ru': {
      'server': 'smtp.yandex.ru',
      'port': 465,
      'ssl': true,
      'username': 'brelock.app@yandex.ru',
      'password': 'vohasjbqaiujeonm',
    },
    'mail.ru': {
      'server': 'smtp.mail.ru',
      'port': 465,
      'username': 'brelock.app@mail.ru',
      'password': 'your_app_password',
    },
  };

  @override
  void initState() {
    super.initState();
    _sendCode(); // Автоматически отправляем код при открытии экрана
  }

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendTimer == 0) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _resendTimer--;
        });
      }
    });
  }

  String _generateRandomCode() {
    final random = Random();
    return List.generate(6, (_) => random.nextInt(10)).join();
  }

  // Определяем домен почты и возвращаем SMTP сервер
  SmtpServer _getSmtpServer(String email) {
    final domain = email.split('@').last.toLowerCase();

    final config = _smtpConfig[domain];
    if (config == null) {
      throw Exception('Почтовый сервис $domain не поддерживается');
    }

    return SmtpServer(
      config['server']!,
      username: config['username']!,
      password: config['password']!,
      port: config['port']!,
      ssl: config['port'] == 465,
    );
  }

  // Проверяем поддерживается ли почтовый сервис
  bool _isEmailSupported(String email) {
    final domain = email.split('@').last.toLowerCase();
    return _smtpConfig.containsKey(domain);
  }

  // Получаем отображаемое имя почтового сервиса
  String _getEmailServiceName(String email) {
    final domain = email.split('@').last.toLowerCase();
    final serviceNames = {
      'gmail.com': 'Gmail',
      'yandex.ru': 'Yandex',
      'ya.ru': 'Yandex',
      'mail.ru': 'Mail.ru',
    };
    return serviceNames[domain] ?? domain;
  }

  Future<void> _sendEmail(String email, String code) async {
    try {
      // Определяем SMTP сервер по домену почты
      final smtpServer = _getSmtpServer(email);
      final serviceName = _getEmailServiceName(email);

      // Создаем сообщение
      final message = Message()
        ..from = Address(_smtpConfig[email.split('@').last.toLowerCase()]!['username']!, 'Brelock App')
        ..recipients.add(email)
        ..subject = 'Код подтверждения для изменения мастер-пароля'
        ..text = '''
Здравствуйте!

Вы запросили изменение мастер-пароля для приложения Brelock.

Ваш код подтверждения: $code

Код действителен в течение 10 минут.

Если вы не запрашивали изменение мастер-пароля, проигнорируйте это письмо.

С уважением,
Команда Brelock
        ''';

      // Отправляем email
      final sendReport = await send(message, smtpServer);
      print('Email отправлен через $serviceName: ${sendReport.toString()}');

    } on MailerException catch (e) {
      print('Ошибка отправки email: $e');
      throw Exception('Не удалось отправить email через ${_getEmailServiceName(email)}: ${e.message}');
    }
  }

  void _sendCode() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Генерируем код
      _generatedCode = _generateRandomCode();

      // Отправляем email
      await _sendEmail(widget.email, _generatedCode);

      setState(() {
        _codeSent = true;
        _canResend = false;
      });

      _startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Код отправлен на вашу почту через ${_getEmailServiceName(widget.email)}")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка отправки кода: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _verifyCode() {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Введите код подтверждения")),
      );
      return;
    }

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Код должен состоять из 6 цифр")),
      );
      return;
    }

    if (code == _generatedCode) {
      setState(() {
        _codeVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Код подтвержден успешно")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Неверный код подтверждения")),
      );
    }
  }

  void _changePassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Валидация
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Заполните все поля")),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Пароль должен содержать минимум 6 символов")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Пароли не совпадают")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Вызовите вашу функцию для изменения мастер-пароля в БД
      // await changeMasterPasswordInDatabase(widget.email, newPassword);
      current_consumer.password = newPassword;
      consumerInteractor.update(current_consumer);
      // Имитация задержки
      await Future.delayed(Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Мастер-пароль успешно изменен")),
      );

      // Возврат на предыдущий экран
      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка при изменении пароля: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
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
                        "Изменение мастер-пароля",
                        style: TextStyle(fontSize: Sizes.fontSizeHeading),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Sizes.spacingMd),
                      Text(
                        widget.email,
                        style: TextStyle(
                          fontSize: Sizes.fontSizeMedium,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Sizes.spacingLg),

                      if (!_codeVerified) ...[
                        // Этап 1: Ввод кода подтверждения
                        Text(
                          "Для изменения мастер-пароля требуется подтверждение",
                          style: TextStyle(
                            fontSize: Sizes.fontSizeMedium,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // Информация о сервисе
                        Container(
                          margin: EdgeInsets.only(top: Sizes.spacingSm),
                          padding: EdgeInsets.all(Sizes.spacingSm),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Письмо отправлено через ${_getEmailServiceName(widget.email)}',
                            style: TextStyle(
                              fontSize: Sizes.fontSizeSmall,
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: Sizes.spacingLg),
                        TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.confirmation_number_outlined),
                            hintText: "Код подтверждения",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                        SizedBox(height: Sizes.spacingMd),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: _verifyCode,
                          child: Text("Подтвердить код"),
                        ),
                        SizedBox(height: Sizes.spacingMd),
                        _canResend
                            ? TextButton(
                          onPressed: _sendCode,
                          child: Text(
                            "Отправить код повторно",
                            style: TextStyle(
                              color: ColorScheme.of(context).primary,
                            ),
                          ),
                        )
                            : Text(
                          "Отправить повторно через $_resendTimer сек.",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ] else ...[
                        // Этап 2: Ввод нового пароля
                        Text(
                          "Введите новый мастер-пароль",
                          style: TextStyle(
                            fontSize: Sizes.fontSizeMedium,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Sizes.spacingLg),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: _obscureNewPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                            hintText: "Новый мастер-пароль",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureNewPassword = !_obscureNewPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: Sizes.spacingSm),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_reset_rounded),
                            hintText: "Повторите новый мастер-пароль",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: Sizes.spacingMd),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: _changePassword,
                          child: Text("Изменить мастер-пароль"),
                        ),
                      ],

                      SizedBox(height: Sizes.spacingSm),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: GestureDetector(
                          child: Text(
                            '← Назад',
                            style: TextStyle(
                              color: ColorScheme.of(context).primary,
                            ),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
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
              'Изменяя мастер-пароль, вы соглашаетесь с',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              child: Text(
                'Политикой конфиденциальности',
                style: TextStyle(color: ColorScheme.of(context).primary),
              ),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Тапнуто")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}