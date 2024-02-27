import 'package:flutter/material.dart';

class AnimationButton extends StatelessWidget {
  final Function() onPressed;
  final Icon icon;

  const AnimationButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(8),
        ),
        child: icon,
      ),
    );
  }
}
