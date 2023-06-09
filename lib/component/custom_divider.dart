import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  final String? text;

  const MyDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Expanded(child: Divider(height: 40,thickness: 1.5,)),
      Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 2, color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              text ?? '',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )),
      const Expanded(child: Divider(height: 40,thickness: 1.5,)),
    ]);
  }
}
