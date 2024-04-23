import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

class PatientsTherapyPlanDetails extends StatelessWidget {
  final Plan plan;

  const PatientsTherapyPlanDetails({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Plan No.:",
                  style: darkTextTheme().headlineSmall,
                ),
                Text(
                  plan.planName.replaceAllMapped(
                    RegExp(r'\D+'),
                    (match) => '',
                  ),
                  style: darkTextTheme().displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start Date:',
                  style: darkTextTheme().headlineSmall,
                ),
                Text(
                  DateFormat('MMMM dd, yyyy').format(plan.startDate),
                  style: darkTextTheme().displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'End Date:',
                  style: darkTextTheme().headlineSmall,
                ),
                Text(
                  DateFormat('MMMM dd, yyyy').format(plan.endDate),
                  style: darkTextTheme().displaySmall,
                ),
                const SizedBox(height: 8),
                // Text(
                //   "Session Progress: ",
                //   style: darkTextTheme().headlineSmall,
                // ),
                // Text(
                //   " ${plan.sessions.indexWhere((session) => session.date.month == DateTime.now().month && session.date.day == DateTime.now().day && session.date.year == DateTime.now().year) + 1}/${plan.sessions.length}",
                //   style: darkTextTheme().displaySmall,
                // ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
