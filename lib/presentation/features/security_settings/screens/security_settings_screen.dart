import 'package:flutter/material.dart';

import '../../../themes/sizes.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Настройки безопасности"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Sizes.spacingMd),
          child: Column(
            children: [
              Center(child: Text("Тут что-то будет"))
            ],
          ),
        ),
      ),
    );
  }
}
