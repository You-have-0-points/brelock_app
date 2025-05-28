import 'package:brelock/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinCodeField extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;

  const PinCodeField({
    required this.length,
    required this.onCompleted
  });

  @override
  State<PinCodeField> createState() => _PinCodeFieldState();
}

class _PinCodeFieldState extends State<PinCodeField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _code = "";

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _focusNodes[0].requestFocus();

  }

  @override
  void dispose() {
    for(var controller in _controllers) {
      controller.dispose();
    }
    for(var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void handleOnChange(int index, String value) {
    setState(() {

      if (value.length > 1) {
        _controllers[index].text = value.substring(0, 1);
        _controllers[index].selection = TextSelection.collapsed(offset: 1);
      }

      _code = _controllers.map((c) => c.text).join();
    });
    if(value.isNotEmpty && index < widget.length-1) {
      _focusNodes[index+1].requestFocus();
    } else if(value.isEmpty && index > 0) {
      _focusNodes[index-1].requestFocus();
    }
    if(_code.length == widget.length) {
      widget.onCompleted(_code);
    }
  }



  @override
  Widget build(BuildContext context) {
  final colorScheme = ColorScheme.of(context);
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: List.generate(widget.length, (index) {
      return SizedBox(
        width: 40,
        height: 50,
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(fontSize: Sizes.fontSizeLarge),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              constraints: BoxConstraints.expand(),
            filled: true,
            fillColor: colorScheme.outlineVariant,
            border: OutlineInputBorder(

            )
          ),
          inputFormatters: [LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            handleOnChange(index, value);
          },
        ),
      );
    })
  );
  }

}
