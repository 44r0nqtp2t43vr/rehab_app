import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';

class TestAnalyticsItem extends StatelessWidget {
  final String itemName;
  final String itemType;
  final double itemAccuracy;

  const TestAnalyticsItem({super.key, required this.itemName, required this.itemType, required this.itemAccuracy});

  Widget _buildAccuracyIndicator() {
    if (itemType == "static pattern") {
      return Text(
        "${itemAccuracy.toString()}%",
        style: darkTextTheme().displaySmall,
      );
    }
    return itemAccuracy == 100 ? const Icon(Icons.check_circle, color: Color(0xff01FF99), size: 24.0) : Icon(Icons.cancel, color: Colors.red.withOpacity(0.3), size: 24.0);
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      shadowStrength: 1,
      shadowColor: Colors.black,
      blur: 4,
      color: Colors.white.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              itemName,
              style: darkTextTheme().headlineSmall,
              overflow: TextOverflow.ellipsis,
            ),
            _buildAccuracyIndicator(),
          ],
        ),
      ),
    );
  }
}
