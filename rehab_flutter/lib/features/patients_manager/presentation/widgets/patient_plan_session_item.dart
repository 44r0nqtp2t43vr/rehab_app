import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/get_testanalytics_data.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/test_analytics/test_analytics_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/test_analytics/test_analytics_event.dart';
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
                        // DateFormat('MMMM dd, yyyy').format(session.date),
                        "no date",
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
                  // const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ElevatedButton(
                  //         onPressed: session.pretestScore == null ? null : () => _onTestButtonPressed(context, patientPlan, session, isPretest: true),
                  //         child: Text(session.pretestScore == null ? "Pretest" : "Pretest: ${session.pretestScore!.toStringAsFixed(0)}"),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     Expanded(
                  //       child: ElevatedButton(
                  //         onPressed: session.posttestScore == null ? null : () => _onTestButtonPressed(context, patientPlan, session, isPretest: false),
                  //         child: Text(session.posttestScore == null ? "Posttest" : "Posttest: ${session.posttestScore!.toStringAsFixed(0)}"),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 8),
                  // Text(
                  //   "Standard One: ${session.standardOneType.isEmpty ? "TBD" : "${standardTherapyTypes.firstWhere((type) => type.value == session.standardOneType).title} ${session.standardOneIntensity}"}",
                  //   style: darkTextTheme().headlineSmall,
                  // ),
                  // Text(
                  //   "Passive Intensity: ${session.passiveIntensity.isEmpty ? "TBD" : session.passiveIntensity}",
                  //   style: darkTextTheme().headlineSmall,
                  // ),
                  // Text(
                  //   "Standard Two: ${session.standardOneType.isEmpty ? "TBD" : "${standardTherapyTypes.firstWhere((type) => type.value == session.standardTwoType).title} ${session.standardTwoIntensity}"}",
                  //   style: darkTextTheme().headlineSmall,
                  // ),
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

  void _onTestButtonPressed(BuildContext context, PatientPlan patientPlan, Session session, {isPretest = true}) {
    // final items = session.items.where((item) => item.test == (isPretest ? "pretest" : "posttest")).toList();
    // items.sort((a, b) => a.itemNumber.compareTo(b.itemNumber));
    BlocProvider.of<TestAnalyticsBloc>(context).add(FetchTestAnalyticsEvent(GetTestAnalyticsData(
      patient: patientPlan.patient,
      plan: patientPlan.plan,
      session: session,
      testType: isPretest ? "pretest" : "posttest",
    )));
    Navigator.of(context).pushNamed("/TestAnalytics");
  }
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
