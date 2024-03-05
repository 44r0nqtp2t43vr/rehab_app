import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;

  const AppIconButton({super.key, this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
