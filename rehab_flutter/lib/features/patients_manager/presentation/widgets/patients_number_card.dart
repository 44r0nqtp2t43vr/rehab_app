import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class PatientsNumberCard extends StatelessWidget {
  final int number;
  final String label;

  const PatientsNumberCard({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      shadowStrength: 2,
      shadowColor: Colors.black,
      blur: 4,
      color: Colors.white.withValues(alpha: 0.25),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "$number",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontFamily: 'Sailec Bold',
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Sailec Light',
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
