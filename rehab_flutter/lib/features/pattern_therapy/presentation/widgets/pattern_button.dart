import 'package:flutter/material.dart';

class PatternButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isActive;

  const PatternButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(
            Colors.white,
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            isActive ? const Color(0xff128BED) : Colors.white.withValues(alpha: .3),
          ),
          elevation: WidgetStateProperty.all<double>(0),
          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(buttonText),
      ),
    );
  }
}
