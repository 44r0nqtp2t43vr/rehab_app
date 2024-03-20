import 'package:flutter/material.dart';

class AppIconButtonText extends StatelessWidget {
  final Icon icon;
  final Text text;
  final void Function() onPressed;

  const AppIconButtonText({super.key, required this.icon, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: text,
    );
  }
}
