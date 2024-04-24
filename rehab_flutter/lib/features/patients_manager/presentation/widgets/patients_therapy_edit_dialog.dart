import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';

class PatientsTherapyEditDialog extends StatelessWidget {
  final PatientPlan patientPlan;
  final Session session;
  final String title;

  const PatientsTherapyEditDialog({super.key, required this.patientPlan, required this.session, required this.title});

  @override
  Widget build(BuildContext context) {
    List<bool> conditions = session.getSessionConditions();

    return GlassContainer(
      blur: 10,
      color: Colors.white.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Sailec Bold',
                    fontSize: 22,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 350,
                  child: Scrollbar(
                    trackVisibility: true,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Row(
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          !conditions[0] ? '0' : session.pretestScore!.toStringAsFixed(1),
                                          style: darkTextTheme().headlineLarge,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Pre-Test Score",
                                          style: darkTextTheme().headlineSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          !conditions[4] ? '0' : session.posttestScore!.toStringAsFixed(1),
                                          style: darkTextTheme().headlineLarge,
                                        ),
                                        Text(
                                          textAlign: TextAlign.center,
                                          "Post-Test Score",
                                          style: darkTextTheme().headlineSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Standard Therapy 1",
                                style: darkTextTheme().displaySmall,
                              ),
                              const SizedBox(height: 4),
                              GlassContainer(
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
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Therapy Type:",
                                            style: darkTextTheme().headlineSmall,
                                          ),
                                          Text(
                                            session.standardOneType,
                                            style: darkTextTheme().displaySmall,
                                          ),
                                          Text(
                                            session.standardOneIntensity,
                                            style: darkTextTheme().headlineLarge,
                                          ),
                                          Text(
                                            "Intensity",
                                            style: darkTextTheme().headlineSmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Passive Therapy",
                                style: darkTextTheme().displaySmall,
                              ),
                              const SizedBox(height: 4),
                              GlassContainer(
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
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              session.passiveIntensity,
                                              style: darkTextTheme().headlineLarge,
                                            ),
                                            Text(
                                              "Intensity",
                                              style: darkTextTheme().headlineSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Standard Therapy 2",
                                style: darkTextTheme().displaySmall,
                              ),
                              const SizedBox(height: 4),
                              GlassContainer(
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
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Therapy Type:",
                                              style: darkTextTheme().headlineSmall,
                                            ),
                                            Text(
                                              session.standardTwoType,
                                              style: darkTextTheme().displaySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              session.standardTwoIntensity,
                                              style: darkTextTheme().headlineLarge,
                                            ),
                                            Text(
                                              "Intensity",
                                              style: darkTextTheme().headlineSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Theme(
                  data: darkButtonTheme,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 12),
                Theme(
                  data: darkButtonTheme,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
