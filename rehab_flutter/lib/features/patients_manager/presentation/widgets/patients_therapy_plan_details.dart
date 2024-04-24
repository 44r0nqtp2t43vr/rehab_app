import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';

class PatientsTherapyPlanDetails extends StatelessWidget {
  final PatientPlan patientPlan;

  const PatientsTherapyPlanDetails({super.key, required this.patientPlan});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Plan No.:",
                //   style: darkTextTheme().headlineSmall,
                // ),
                // Text(
                //   plan.planName.replaceAllMapped(
                //     RegExp(r'\D+'),
                //     (match) => '',
                //   ),
                //   style: darkTextTheme().displaySmall,
                // ),
                // const SizedBox(height: 8),
                Text(
                  'Patient Name:',
                  style: darkTextTheme().headlineSmall,
                ),
                Text(
                  patientPlan.patient.getUserFullName(),
                  style: darkTextTheme().displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start Date:',
                  style: darkTextTheme().headlineSmall,
                ),
                Text(
                  DateFormat('MMMM dd, yyyy').format(patientPlan.plan.startDate),
                  style: darkTextTheme().displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'End Date:',
                  style: darkTextTheme().headlineSmall,
                ),
                Text(
                  DateFormat('MMMM dd, yyyy').format(patientPlan.plan.endDate),
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
