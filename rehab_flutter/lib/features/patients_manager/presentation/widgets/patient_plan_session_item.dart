import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
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
            color: Colors.white.withValues(alpha: 0.25),
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
                                color: dailyActivityBools[0] ? const Color(0xFF01B36C) : Colors.red.withValues(alpha: 0.3),
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
                                color: dailyActivityBools[1] ? const Color(0xFF01B36C) : Colors.red.withValues(alpha: 0.3),
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
                                color: dailyActivityBools[2] ? const Color(0xFF01B36C) : Colors.red.withValues(alpha: 0.3),
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
                          color: Colors.white.withValues(alpha: 0.3),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _onTestButtonPressed(context),
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
            "Week ${index + 1}",
          ),
          child: GlassContainer(
            shadowStrength: 2,
            shadowColor: Colors.black,
            blur: 4,
            color: Colors.white.withValues(alpha: 0.25),
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

  void _onTestButtonPressed(BuildContext context) {
    Navigator.of(context).pushNamed("/TestAnalytics", arguments: session.testingItems);
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
