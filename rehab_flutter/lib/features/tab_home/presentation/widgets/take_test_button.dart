import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';

class TakeTestButton extends StatelessWidget {
  const TakeTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: 10,
      color: Colors.white.withValues(alpha: 0.3),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onButtonPressed(context),
          child: Container(
            height: 32,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                "Tap here to take your weekly test",
                style: darkTextTheme().headlineSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Testing', arguments: true);
  }
}
