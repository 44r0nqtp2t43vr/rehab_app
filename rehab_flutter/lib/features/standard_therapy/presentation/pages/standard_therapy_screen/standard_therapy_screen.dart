import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_therapy_data.dart';

class StandardTherapyScreen extends StatefulWidget {
  final StandardTherapyData data;

  const StandardTherapyScreen({super.key, required this.data});

  @override
  State<StandardTherapyScreen> createState() => _StandardTherapyScreenState();
}

class _StandardTherapyScreenState extends State<StandardTherapyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "${widget.data.type.name} ${widget.data.intensity}",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
