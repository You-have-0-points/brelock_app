import 'package:brelock/domain/entities/consumer.dart';
import 'package:flutter/material.dart';
import '../../../themes/sizes.dart';
import 'package:brelock/di_injector.dart';
import '../../login/screens/login_screen.dart';
import '../../password_list/screens/password_list_screen.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final RegExp _passwordRegex = RegExp(r'^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]*$');
  final RegExp _emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  padding: EdgeInsets.fromLTRB(Sizes.spacingMd, 0, Sizes.spacingMd, Sizes.spacingMd),
                  child: Form(
                    child: Column(
                      children: [
                        Text(l10n!.registrationTitle, style: TextStyle(fontSize: Sizes.fontSizeHeading),),
                        SizedBox(height: Sizes.spacingMd,),
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
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password_rounded),
                            hintText: l10n.repeatMasterPassword,
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
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: GestureDetector(
                            child: Text(
                              l10n.alreadyHaveAccount,
                              style: TextStyle(
                                color: ColorScheme.of(context).primary,
                              ),
                            ),
                            onTap:
                                () =>
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                ),
                          ),
                        ),
                        SizedBox(height: Sizes.spacingMd),
                        ElevatedButton(
                            onPressed: _isLoading ? null : () async {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              final confirmPassword = _confirmPasswordController.text.trim();

                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.enterEmail)),
                                );
                                return;
                              }

                              if (!_emailRegex.hasMatch(email)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.enterValidEmail)),
                                );
                                return;
                              }

                              if (password != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.passwordsNotMatch)),
                                );
                                return;
                              }

                              if (!_passwordRegex.hasMatch(password)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.passwordLatinOnly),
                                  ),
                                );
                                return;
                              }

                              if (password.length < 8){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.passwordMin8Chars),
                                  ),
                                );
                                return;
                              }

                              try {
                                await consumerInteractor.getByEmail(email);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.userAlreadyExists),
                                  ),
                                );
                                return;
                              }catch(e){}
                              setState(() => _isLoading = true);
                              await consumerInteractor.create(email, password);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PasswordListScreen()));
                            },
                            child: Text(l10n.register)
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
                  l10n.registrationAgreement,
                  style: TextStyle(color: Colors.grey),
                ),
                GestureDetector(
                  child: Text(
                    l10n.privacyPolicy,
                    style: TextStyle(color: ColorScheme.of(context).primary),
                  ),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.privacyPolicy))),
                )
              ],
            )
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {}
}