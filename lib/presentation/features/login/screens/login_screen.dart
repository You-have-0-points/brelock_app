import 'package:brelock/domain/entities/consumer.dart';
import 'package:brelock/presentation/features/password_list/screens/password_list_screen.dart';
import 'package:brelock/presentation/features/forgot_password/forgot_password_screen.dart';
import 'package:brelock/presentation/features/register/screens/register_screen.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:brelock/di_injector.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        _showExitDialog(context);
      },
      child: Scaffold(
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
                          l10n!.login,
                          style: TextStyle(fontSize: Sizes.fontSizeHeading),
                        ),
                        SizedBox(height: Sizes.spacingMd),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                            hintText: l10n.emailAddress,
                          ),
                        ),
                        SizedBox(height: Sizes.spacingSm),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password_rounded),
                            hintText: l10n.masterPassword,
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
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: GestureDetector(
                              child: Text(
                                l10n.forgotPassword,
                                style: TextStyle(
                                  color: ColorScheme.of(context).primary,
                                ),
                              ),
                              onTap:
                                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()))
                          ),
                        ),
                        SizedBox(height: Sizes.spacingMd),
                        ElevatedButton(onPressed: () async {
                          Consumer cons = (await consumerRepository.getByLoginData(_emailController.text.trim(), _passwordController.text.trim()))!;
                          if(cons != null){
                            print("FIRST RULE OF FIGHT CLUB IS ${cons.id}");
                            current_consumer.copy(cons);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordListScreen()));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.wrongLoginOrPassword)),
                            );
                          }
                        }, child: Text(l10n.signIn)),
                        SizedBox(height: Sizes.spacingMd),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.noAccount,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(width: Sizes.spacingXs),
                                GestureDetector(
                                  child: Text(
                                    l10n.registration,
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
                l10n.loginAgreement,
                style: TextStyle(color: Colors.grey),
              ),
              GestureDetector(
                child: Text(
                  l10n.privacyPolicy,
                  style: TextStyle(color: ColorScheme.of(context).primary),
                ),
                onTap:
                    () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.tapped))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {}
}