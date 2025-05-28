import 'package:brelock/themes/sizes.dart';
import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // <-- Добавляет отступ снизу под клавиатуру
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
            Text("Новая категория", style: TextStyle(fontSize: Sizes.fontSizeHeading),),
            SizedBox(height: Sizes.spacingSm),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.title_outlined),
                hintText: "Название",
              ),
            ),
            SizedBox(height: Sizes.spacingSm),
            ElevatedButton(onPressed: () {}, child: Text("Добавить")),
          ],
        ),
      ),
    );
  }
}
