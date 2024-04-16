import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

class PatientPlanItem extends StatelessWidget {
  final Plan plan;
  final int planNo;
  final bool isCurrent;

  const PatientPlanItem(
      {super.key,
      required this.plan,
      required this.planNo,
      required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      shadowStrength: 2,
      shadowColor: Colors.black,
      blur: 4,
      color: isCurrent
          ? const Color(0xff01FF99).withOpacity(0.25)
          : Colors.white.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Center(
                child: Text(
                  "$planNo",
                  style: darkTextTheme().headlineSmall,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMMM dd, yyyy').format(plan.startDate),
                    style: darkTextTheme().headlineSmall,
                  ),
                  Text(
                    DateFormat('MMMM dd, yyyy').format(plan.endDate),
                    style: darkTextTheme().headlineSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${plan.getPlanPercentCompletion().toStringAsFixed(2)}%",
                  style: darkTextTheme().headlineSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
