import 'package:brelock/di_injector.dart';
import 'package:brelock/domain/entities/password.dart';
import 'package:brelock/domain/value_objects/service.dart';
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
  late TextEditingController _urlController;
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  late TextEditingController _serviceNameController;

  bool _isEditing = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.selectedPassword?.serviceName.url ?? '');
    _loginController = TextEditingController(text: widget.selectedPassword?.login ?? '');
    _passwordController = TextEditingController(text: widget.selectedPassword?.secret ?? '');
    _serviceNameController = TextEditingController(text: widget.selectedPassword?.serviceName.name ?? '');
  }

  @override
  void dispose() {
    _urlController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _serviceNameController.dispose();
    super.dispose();
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

  Future<void> _saveChanges() async {
    if (widget.selectedPassword == null) return;

    final l10n = AppLocalizations.of(context);

    try {
      // Обновляем данные пароля
      final updatedPassword = Password(
        id: widget.selectedPassword!.id,
        serviceName: Service(
          _serviceNameController.text.trim(),
          _urlController.text.trim(),
          widget.selectedPassword!.serviceName.id,
        ),
        login: _loginController.text.trim(),
        secret: _passwordController.text.trim(),
        isFavourite: widget.selectedPassword!.isFavourite,
        createdAt: widget.selectedPassword!.createdAt,
        updatedAt: DateTime.now(),
        userId: widget.selectedPassword!.userId,
      );

      await passwordInteractor.update(updatedPassword);

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Изменения сохранены')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $e')),
      );
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      // Восстанавливаем оригинальные значения
      _urlController.text = widget.selectedPassword?.serviceName.url ?? '';
      _loginController.text = widget.selectedPassword?.login ?? '';
      _passwordController.text = widget.selectedPassword?.secret ?? '';
      _serviceNameController.text = widget.selectedPassword?.serviceName.name ?? '';
    });
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

  Widget _buildEditableField(String label, String value, IconData icon, TextEditingController controller, {bool obscureText = false, bool isPassword = false}) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: Sizes.spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            readOnly: !_isEditing,
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: label,
              suffixIcon: _isEditing && isPassword
                  ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
                  : !_isEditing && value.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.content_copy, size: 20),
                onPressed: () => _copyToClipboard(value, label),
                tooltip: 'Копировать $label',
              )
                  : null,
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
          if (!_isEditing) ...[
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              tooltip: 'Редактировать',
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _showDeleteConfirmationDialog,
              tooltip: l10n.deletePassword,
            ),
          ] else ...[
            IconButton(
              icon: Icon(Icons.save_outlined),
              onPressed: _saveChanges,
              tooltip: 'Сохранить',
            ),
            IconButton(
              icon: Icon(Icons.close_outlined),
              onPressed: _cancelEditing,
              tooltip: 'Отменить',
            ),
          ]
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

                _buildEditableField(
                  l10n.url,
                  widget.selectedPassword!.serviceName.url,
                  Icons.link,
                  _urlController,
                ),

                _buildEditableField(
                  l10n.username,
                  widget.selectedPassword!.login,
                  Icons.account_circle_outlined,
                  _loginController,
                ),

                Container(
                  margin: EdgeInsets.only(bottom: Sizes.spacingSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        readOnly: !_isEditing,
                        obscureText: !_isEditing ? true : _obscurePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password_rounded),
                          hintText: l10n.password,
                          suffixIcon: _isEditing
                              ? IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          )
                              : widget.selectedPassword!.secret.isNotEmpty
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

                _buildEditableField(
                  l10n.serviceName,
                  widget.selectedPassword!.serviceName.name,
                  Icons.title_outlined,
                  _serviceNameController,
                ),

                if (_isEditing) ...[
                  SizedBox(height: Sizes.spacingMd),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _cancelEditing,
                          child: Text('Отменить'),
                        ),
                      ),
                      SizedBox(width: Sizes.spacingSm),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          child: Text('Сохранить'),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: Sizes.spacingMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}