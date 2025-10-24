import 'package:brelock/di_injector.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';
import 'dart:async';
import 'package:brelock/presentation/features/change_password/change_password.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _codeSent = false;
  bool _canResend = true;
  int _resendTimer = 0;
  String _generatedCode = '';
  Timer? _timer;

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
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
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

  bool _isEmailSupported(String email) {
    final domain = email.split('@').last.toLowerCase();
    return _smtpConfig.containsKey(domain);
  }

  String _getEmailServiceName(String email) {
    final domain = email.split('@').last.toLowerCase();
    final serviceNames = {
      'gmail.com': 'Gmail',
      'yandex.ru': 'Yandex',
    };
    return serviceNames[domain] ?? domain;
  }

  Future<void> _sendEmail(String email, String code) async {
    try {
      final smtpServer = _getSmtpServer(email);
      final serviceName = _getEmailServiceName(email);

      final message = Message()
        ..from = Address(_smtpConfig[email.split('@').last.toLowerCase()]!['username']!, 'Brelock App')
        ..recipients.add(email)
        ..subject = 'Код подтверждения для восстановления пароля'
        ..text = '''
Здравствуйте!

Вы запросили восстановление пароля для приложения Brelock.

Ваш код подтверждения: $code

Код действителен в течение 10 минут.

Если вы не запрашивали восстановление пароля, проигнорируйте это письмо.

С уважением,
Команда Brelock
        ''';

      final sendReport = await send(message, smtpServer);
      print('Email отправлен через $serviceName: ${sendReport.toString()}');

    } on MailerException catch (e) {
      print('Ошибка отправки email: $e');
      throw Exception('Не удалось отправить email через ${_getEmailServiceName(email)}: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                        l10n!.passwordRecovery,
                        style: TextStyle(fontSize: Sizes.fontSizeHeading),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Sizes.spacingMd),

                      if (!_codeSent) ...[
                        Text(
                          l10n.enterEmailForCode,
                          style: TextStyle(
                            fontSize: Sizes.fontSizeMedium,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Sizes.spacingLg),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                            hintText: l10n.emailAddress,
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),

                        Container(
                          margin: EdgeInsets.only(top: Sizes.spacingSm),
                          padding: EdgeInsets.all(Sizes.spacingSm),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.supportedServices,
                            style: TextStyle(
                              fontSize: Sizes.fontSizeSmall,
                              color: Colors.blue[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: Sizes.spacingMd),
                        _isLoading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: _sendCode,
                          child: Text(l10n.sendCode),
                        ),
                      ] else ...[
                        Text(
                          l10n.codeSentToEmail(_emailController.text),
                          style: TextStyle(
                            fontSize: Sizes.fontSizeMedium,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        Container(
                          margin: EdgeInsets.only(top: Sizes.spacingSm),
                          padding: EdgeInsets.all(Sizes.spacingSm),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.emailSentVia(_getEmailServiceName(_emailController.text)),
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
                            hintText: l10n.confirmationCode,
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
                          child: Text(l10n.confirm),
                        ),
                        SizedBox(height: Sizes.spacingMd),
                        _canResend
                            ? TextButton(
                          onPressed: _resendCode,
                          child: Text(
                            l10n.resendCode,
                            style: TextStyle(
                              color: ColorScheme.of(context).primary,
                            ),
                          ),
                        )
                            : Text(
                          l10n.resendInSeconds(_resendTimer.toString()),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],

                      SizedBox(height: Sizes.spacingSm),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: GestureDetector(
                          child: Text(
                            '← ${l10n.backToLogin}',
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
              l10n.recoveringPasswordAgreement,
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              child: Text(
                l10n.privacyPolicy,
                style: TextStyle(color: ColorScheme.of(context).primary),
              ),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.tapped)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendCode() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.enterEmail)),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.enterValidEmail)),
      );
      return;
    }

    if (!_isEmailSupported(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Почтовый сервис не поддерживается. Используйте Gmail, Yandex или Mail.ru")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _generatedCode = _generateRandomCode();
      await _sendEmail(email, _generatedCode);

      setState(() {
        _codeSent = true;
        _canResend = false;
      });

      _startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Код отправлен на вашу почту через ${_getEmailServiceName(email)}")),
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

  void _verifyCode() async {
    final l10n = AppLocalizations.of(context);
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.enterEmail)),
      );
      return;
    }

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Код должен состоять из 6 цифр")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (code == _generatedCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.codeVerifiedSuccess)),
        );

        current_consumer = await consumerRepository.getByEmail(_emailController.text.trim());
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: _emailController.text)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n!.wrongCode)),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.codeVerificationError(e.toString()))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resendCode() async {
    final l10n = AppLocalizations.of(context);

    if (!_canResend) return;

    setState(() {
      _canResend = false;
      _isLoading = true;
    });

    try {
      _generatedCode = _generateRandomCode();
      await _sendEmail(_emailController.text.trim(), _generatedCode);

      _startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.codeResent)),
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
}