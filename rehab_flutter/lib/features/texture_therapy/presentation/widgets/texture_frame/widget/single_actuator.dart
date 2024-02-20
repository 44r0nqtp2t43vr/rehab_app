import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SingleActuator extends StatefulWidget {
  final ui.Offset? tapPosition;
  final Color tappedColor;
  final int value;

  const SingleActuator({
    Key? key,
    this.tapPosition,
    required this.tappedColor,
    required this.value,
  }) : super(key: key);

  @override
  _SingleActuatorState createState() => _SingleActuatorState();
}

class _SingleActuatorState extends State<SingleActuator> {
  int value = 0;
  bool isActivated = true;

  @override
  void initState() {
    super.initState();
    if (widget.tappedColor != Colors.green) {
      isActivated = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Perform the calculation inside build to ensure access to widget properties
    final double adjustedLeft = (widget.tapPosition?.dx ?? 0) -
        10; // Center horizontally with null check
    final double adjustedTop =
        (widget.tapPosition?.dy ?? 0) - 10; // Center vertically with null check

    return Positioned(
      left: adjustedLeft,
      top: adjustedTop,
      child: Container(
        width: 10, // Circle size
        height: 10,

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.tappedColor,
        ),
      ),
    );
  }
}
