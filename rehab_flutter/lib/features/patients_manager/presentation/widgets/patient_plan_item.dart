import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

class PatientPlanItem extends StatelessWidget {
  final Plan plan;
  final int planNo;
  final bool isCurrent;

  const PatientPlanItem({super.key, required this.plan, required this.planNo, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isCurrent ? Colors.green : Colors.white),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
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
    );
  }
}
