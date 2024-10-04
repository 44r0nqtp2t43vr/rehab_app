import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
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
                        'Week ${index + 1}',
                        style: darkTextTheme().displaySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${session.getSessionPercentCompletion().toStringAsFixed(2)}%',
                        style: darkTextTheme().displaySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: session.dailyActivities.length,
                    itemBuilder: (context, i) {
                      final dailyActivity = session.dailyActivities[i];
                      final dailyActivityDetails = session.getDayActivitiesDetailsFromDayActivities(dailyActivity);
                      final dailyActivityBools = session.getDayActivitiesConditionsFromDayActivities(dailyActivity);
                      final dailyActivityDateString = formatDateToDayMonth(parseMMDDYYYY(dailyActivity.split("_")[0]));

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dailyActivityDateString,
                                style: darkTextTheme().headlineSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              width: 48.0,
                              height: 28.0,
                              decoration: BoxDecoration(
                                color: dailyActivityBools[0] ? const Color(0xFF01B36C) : Colors.red.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  dailyActivityDetails[0],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 48.0,
                              height: 28.0,
                              decoration: BoxDecoration(
                                color: dailyActivityBools[1] ? const Color(0xFF01B36C) : Colors.red.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  dailyActivityDetails[1],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 48.0,
                              height: 28.0,
                              decoration: BoxDecoration(
                                color: dailyActivityBools[2] ? const Color(0xFF01B36C) : Colors.red.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  dailyActivityDetails[2],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  session.testingItems.isEmpty
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                            child: Text(
                              'Test taken on ${formatDateMMDDYYYYY(session.getTestTakenDate()!)}',
                              textAlign: TextAlign.center,
                              style: darkTextTheme().displaySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                  session.testingItems.isEmpty
                      ? const SizedBox()
                      : GlassContainer(
                          blur: 10,
                          color: Colors.white.withOpacity(0.3),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                height: 32,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Score: ${session.getTestScore().toStringAsFixed(2)}",
                                    style: darkTextTheme().headlineSmall,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
