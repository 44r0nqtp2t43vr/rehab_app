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
          foregroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            isActive ? const Color(0xff128BED) : Colors.white.withOpacity(.3),
          ),
          elevation: MaterialStateProperty.all<double>(0),
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
