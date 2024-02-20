import 'package:flutter/material.dart';

class PatternButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PatternButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}
