import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_edit_dialog.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_session_details.dart';

class PatientPlanSessionItem extends StatelessWidget {
  final PatientPlan patientPlan;
  final Session session;
  final int index;

  const PatientPlanSessionItem({super.key, required this.patientPlan, required this.session, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _showContentDialog(
              context,
              session,
              "Session ${index + 1}",
            ),
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
                child: Row(
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
}

void _showContentDialog(BuildContext context, Session session, String title) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        content: PatientsTherapySessionDetails(session: session, title: title),
      );
    },
  );
}

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
