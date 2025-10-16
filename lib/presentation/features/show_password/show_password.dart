import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/presentation/features/generate_password/screens/generate_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:uuid/uuid.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';

class ShowPasswordScreen extends StatefulWidget {
  final Password? selectedPassword;

  ShowPasswordScreen({
    required this.selectedPassword,
    super.key
  });

  @override
  State<ShowPasswordScreen> createState() => _ShowPasswordScreenState();
}

class _ShowPasswordScreenState extends State<ShowPasswordScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _copyToClipboard(String text, String fieldName) {
    final l10n = AppLocalizations.of(context);

    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n!.copiedToClipboard(fieldName))),
      );
    }
  }

  Future<void> _deletePassword() async{
    await folderInteractor.deletePassword(current_consumer, widget.selectedPassword!);
    await passwordInteractor.delete(widget.selectedPassword!);

    Navigator.pop(context);
  }

  void _showDeleteConfirmationDialog() {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n!.deletePassword),
        content: Text(l10n.deleteConfirmation(widget.selectedPassword?.serviceName.name ?? "")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async{
              Navigator.pop(context);
              await _deletePassword();
            },
            child: Text(
              l10n.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayField(String label, String value, IconData icon) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: Sizes.spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            readOnly: true,
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: label,
              suffixIcon: value.isNotEmpty ? IconButton(
                icon: Icon(Icons.content_copy, size: 20),
                onPressed: () => _copyToClipboard(value, label),
                tooltip: 'Копировать $label',
              ) : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = ColorScheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.passwordData),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _showDeleteConfirmationDialog,
            tooltip: l10n.deletePassword,
          ),
        ],
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
            child: Column(
              children: [
                SizedBox(height: Sizes.spacingMd),

                _buildDisplayField(
                  l10n.url,
                  widget.selectedPassword!.serviceName.url,
                  Icons.link,
                ),

                _buildDisplayField(
                  l10n.username,
                  widget.selectedPassword!.login,
                  Icons.account_circle_outlined,
                ),

                Container(
                  margin: EdgeInsets.only(bottom: Sizes.spacingSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        readOnly: true,
                        obscureText: true,
                        controller: TextEditingController(
                            text: widget.selectedPassword!.secret.isNotEmpty
                                ? '••••••••'
                                : 'Не указано'
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password_rounded),
                          hintText: l10n.password,
                          suffixIcon: widget.selectedPassword!.secret.isNotEmpty
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.visibility, size: 20),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(l10n.password),
                                      content: SelectableText(widget.selectedPassword!.secret),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(l10n.close),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _copyToClipboard(widget.selectedPassword!.secret, l10n.password);
                                            Navigator.pop(context);
                                          },
                                          child: Text(l10n.copy),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                tooltip: l10n.showPassword,
                              ),
                              IconButton(
                                icon: Icon(Icons.content_copy, size: 20),
                                onPressed: () => _copyToClipboard(widget.selectedPassword!.secret, l10n.password),
                                tooltip: 'Копировать ${l10n.password}',
                              ),
                            ],
                          )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildDisplayField(
                  l10n.serviceName,
                  widget.selectedPassword!.serviceName.name,
                  Icons.title_outlined,
                ),

                SizedBox(height: Sizes.spacingMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}