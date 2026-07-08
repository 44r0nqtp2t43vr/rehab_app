import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';

class TestAnalyticsItem extends StatelessWidget {
  final String itemName;
  final String answer;
  final bool isCorrect;

  const TestAnalyticsItem({super.key, required this.itemName, required this.answer, required this.isCorrect});

  Widget _buildAccuracyIndicator() {
    return Container(
      width: 40.0, // Define the size of the square
      height: 40.0,
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFF01B36C) : Colors.red.withValues(alpha: 0.3), // Background color based on isCorrect
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      child: Center(
        child: Icon(
          isCorrect ? Icons.check : Icons.close, // Icon based on isCorrect
          color: Colors.white, // Icon color is always white
          size: 24.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: GlassContainer(
            shadowStrength: 1,
            // shadowColor: Colors.black,
            blur: 4,
            color: Colors.white.withValues(alpha: 0.25),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              child: Text(
                itemName,
                textAlign: TextAlign.center,
                style: darkTextTheme().headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: GlassContainer(
            shadowStrength: 1,
            // shadowColor: Colors.black,
            blur: 4,
            color: Colors.white.withValues(alpha: 0.25),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              child: Text(
                answer,
                textAlign: TextAlign.center,
                style: darkTextTheme().headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: _buildAccuracyIndicator(),
        ),
      ],
    );
  }
}
