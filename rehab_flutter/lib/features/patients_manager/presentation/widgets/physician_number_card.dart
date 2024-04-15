import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';

class PhysicianNumberCard extends StatelessWidget {
  final int number;
  final String label;

  const PhysicianNumberCard({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "$number",
                textAlign: TextAlign.end,
                style: darkTextTheme().headlineLarge,
              ),
            ),
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: darkTextTheme().headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
