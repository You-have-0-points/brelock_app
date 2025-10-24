import 'package:brelock/di_injector.dart';
import 'package:brelock/presentation/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:brelock/l10n/generated/app_localizations.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(Sizes.buttonRadius))
        ),
        padding: EdgeInsets.all(Sizes.spacingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(l10n!.newCategory, style: TextStyle(fontSize: Sizes.fontSizeHeading),),
            SizedBox(height: Sizes.spacingSm),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.title_outlined),
                hintText: l10n.categoryName,
              ),
            ),
            SizedBox(height: Sizes.spacingSm),
            ElevatedButton(onPressed: () async{
              if(_nameController.text.trim().isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.enterFolderName)),
                );
                return;
              }

              if((await folderRepository.getByName(_nameController.text.trim(), current_consumer)) != null){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.folderAlreadyExists)),
                );
                return;
              }

              await folderInteractor.create(_nameController.text.trim());
              Navigator.of(context).pop(true);
            }, child: Text(l10n.add)),
          ],
        ),
      ),
    );
  }
}