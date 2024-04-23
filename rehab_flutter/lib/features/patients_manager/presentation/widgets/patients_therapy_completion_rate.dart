import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

class PatientsTherapyCompletionRate extends StatelessWidget {
  final Plan plan;

  const PatientsTherapyCompletionRate({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassContainer(
        shadowStrength: 2,
        shadowColor: Colors.black,
        blur: 4,
        color: Colors.white.withOpacity(0.25),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 0.4 * 136,
                lineWidth: 10.0,
                percent: plan.getPlanPercentCompletion() / 100,
                center: Text(
                  "${plan.getPlanPercentCompletion().toStringAsFixed(2)}%",
                  style: const TextStyle(
                    fontFamily: "Sailec Bold",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white,
                progressColor: const Color(0xff01FF99),
              ),
              const SizedBox(height: 16),
              Text(
                "Therapy Plan Completion Rate",
                style: darkTextTheme().headlineSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
