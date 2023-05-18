import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String placeHolder;
  final TextEditingController? textEditingController;
  final bool obscureText;
  final bool? enabled;
  final String? errorText;
  final String? labelText;
  final void Function()? validText;

  const MyTextField({
    super.key,
    required this.placeHolder,
    required this.textEditingController,
    required this.errorText,
    this.obscureText = false,
    this.validText,
    this.labelText,
    this.enabled = true,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enabled,
      obscureText: widget.obscureText,
      cursorColor: Colors.grey,
      controller: widget.textEditingController,
      style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      onChanged: (value) {
        if (widget.textEditingController!.text.isNotEmpty) {
          widget.validText?.call();
        }
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        errorStyle: const TextStyle(fontSize: 12),
        //để null thì khi ko bị lỗi, textfield ko bị bôi đỏ viền
        hintText: widget.placeHolder,
        hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
