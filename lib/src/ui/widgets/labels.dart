import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String labelText;

  const CustomLabel(this.labelText);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:7.0),
      child: Text(
        '$labelText',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
      ),
    );
  }
}
