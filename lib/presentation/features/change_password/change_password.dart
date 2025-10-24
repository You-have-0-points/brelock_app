import 'package:brelock/di_injector.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:brelock/presentation/features/login/screens/login_screen.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                        l10n!.changePassword,
                        style: TextStyle(fontSize: Sizes.fontSizeHeading),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Sizes.spacingMd),
                      Text(
                        "${l10n.forr} ${widget.email}",
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
                          hintText: l10n.newPassword,
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
                          hintText: l10n.repeatNewPassword,
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
                        onPressed: _resetPassword,
                        child: Text(l10n.confirm),
                      ),
                      SizedBox(height: Sizes.spacingSm),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: GestureDetector(
                          child: Text(
                            '← ${l10n.back}',
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
              l10n.changingPasswordAgreement,
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

  void _resetPassword() async {
    final l10n = AppLocalizations.of(context);
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.fillAllFields)),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.passwordMinLength)),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.passwordsNotMatch)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      current_consumer.password = newPassword;
      consumerInteractor.update(current_consumer);
      await Future.delayed(Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.passwordChangedSuccess)),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.passwordChangeError(e.toString()))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}