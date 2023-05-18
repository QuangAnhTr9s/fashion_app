import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class TextFieldWithValid extends StatefulWidget {
  const TextFieldWithValid({
    super.key,
    required this.stream,
    required this.textEditingController,
    required this.validText,
    required this.placeHolder,
    this.labelText,
    this.obscureText = false,
    this.enabled = true,
  });

  final Stream<String> stream;
  final TextEditingController textEditingController;
  final Function validText;
  final String placeHolder;
  final String? labelText;
  final bool obscureText;
  final bool enabled;

  @override
  State<TextFieldWithValid> createState() => _TextFieldWithValidState();
}

class _TextFieldWithValidState extends State<TextFieldWithValid> {
  late bool _isTextFieldEmpty;

  @override
  void initState() {
    super.initState();
    _isTextFieldEmpty = widget.textEditingController.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: widget.stream,
        builder: (context, snapshotTextField) {
          final String? errorTextEmail;
          if (snapshotTextField.hasError) {
            errorTextEmail = snapshotTextField.error.toString();
            _isTextFieldEmpty = false;
          } else {
            _isTextFieldEmpty = true;
            errorTextEmail = null;
          }
          return MyTextField(
            labelText: widget.labelText,
            enabled: widget.enabled,
            validText: () {
              if (widget.textEditingController.text.isNotEmpty) {
                widget.validText(widget.textEditingController.text.trim());
              }
            },
            // validText: widget.textEditingController.text.isEmpty == false ? widget.validText(widget.textEditingController.text.trim()) : null,
            placeHolder: widget.placeHolder,
            textEditingController: widget.textEditingController,
            obscureText: widget.obscureText,
            errorText: _isTextFieldEmpty ? null : errorTextEmail,
          );
        });
  }
}
