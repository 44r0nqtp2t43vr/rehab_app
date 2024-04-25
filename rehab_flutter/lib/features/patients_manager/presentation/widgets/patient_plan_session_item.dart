import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_edit_dialog.dart';

class PatientPlanSessionItem extends StatelessWidget {
  final PatientPlan patientPlan;
  final Session session;
  final int index;

  const PatientPlanSessionItem({super.key, required this.patientPlan, required this.session, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GlassContainer(
            shadowStrength: 1,
            shadowColor: Colors.black,
            blur: 4,
            color: Colors.white.withOpacity(0.25),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Session ${index + 1}',
                        style: darkTextTheme().headlineSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(session.date),
                        style: darkTextTheme().headlineSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${session.getSessionPercentCompletion()}%',
                        style: darkTextTheme().headlineSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: session.items.isEmpty || !(session.items.any((item) => item.test == "pretest")) ? null : () => _onTestButtonPressed(context, isPretest: true),
                          child: Text(session.items.isEmpty ? "Pretest" : "Pretest: ${session.pretestScore!.toStringAsFixed(0)}"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: session.items.isEmpty || !(session.items.any((item) => item.test == "posttest")) ? null : () => _onTestButtonPressed(context, isPretest: false),
                          child: Text(session.items.isEmpty ? "Posttest" : "Posttest: ${session.posttestScore!.toStringAsFixed(0)}"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Standard One: ${session.standardOneType.isEmpty ? "TBD" : "${session.standardOneType} ${session.standardOneIntensity}"}",
                    style: darkTextTheme().headlineSmall,
                  ),
                  Text(
                    "Passive Intensity: ${session.passiveIntensity.isEmpty ? "TBD" : session.passiveIntensity}",
                    style: darkTextTheme().headlineSmall,
                  ),
                  Text(
                    "Standard Two: ${session.standardOneType.isEmpty ? "TBD" : "${session.standardTwoType} ${session.standardTwoIntensity}"}",
                    style: darkTextTheme().headlineSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _showEditDialog(
            context,
            patientPlan,
            session,
            "Session ${index + 1}",
          ),
          child: GlassContainer(
            shadowStrength: 2,
            shadowColor: Colors.black,
            blur: 4,
            color: Colors.white.withOpacity(0.25),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                CupertinoIcons.pencil,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _onTestButtonPressed(BuildContext context, {isPretest = true}) {
    final items = session.items.where((item) => item.test == (isPretest ? "pretest" : "posttest")).toList();
    items.sort((a, b) => a.itemNumber.compareTo(b.itemNumber));

    Navigator.of(context).pushNamed("/TestAnalytics", arguments: items);
  }
}

// void _showContentDialog(BuildContext context, Session session, String title) {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
//         surfaceTintColor: Colors.transparent,
//         backgroundColor: Colors.transparent,
//         content: PatientsTherapySessionDetails(session: session, title: title),
//       );
//     },
//   );
// }

void _showEditDialog(BuildContext context, PatientPlan patientPlan, Session session, String title) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        content: PatientsTherapyEditDialog(patientPlan: patientPlan, session: session, title: title),
      );
    },
  );
}
