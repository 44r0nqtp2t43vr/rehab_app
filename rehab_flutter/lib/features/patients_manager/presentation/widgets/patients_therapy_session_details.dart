import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';

class PatientsTherapySessionDetails extends StatelessWidget {
  final Plan plan;
  final int i;
  final String title;

  const PatientsTherapySessionDetails(
      {super.key, required this.plan, required this.i, required this.title});

  @override
  Widget build(BuildContext context) {
    List<bool> conditions = plan.sessions[i].getSessionConditions();

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
                  height: conditions[0] == false ? 150 : 350,
                  child: Scrollbar(
                    trackVisibility: true,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: conditions[0] == false
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 32),
                                Text(
                                  textAlign: TextAlign.center,
                                  'User did not do any Therapy Session.',
                                  style: darkTextTheme().headlineMedium,
                                ),
                              ],
                            )
                          : Column(
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                plan.sessions[i].pretestScore!
                                                    .toStringAsFixed(1),
                                                style: darkTextTheme()
                                                    .headlineLarge,
                                              ),
                                              Text(
                                                textAlign: TextAlign.center,
                                                "Pre-Test Score",
                                                style: darkTextTheme()
                                                    .headlineSmall,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                !conditions[4]
                                                    ? '0'
                                                    : plan.sessions[i]
                                                        .posttestScore!
                                                        .toStringAsFixed(1),
                                                style: darkTextTheme()
                                                    .headlineLarge,
                                              ),
                                              Text(
                                                textAlign: TextAlign.center,
                                                "Post-Test Score",
                                                style: darkTextTheme()
                                                    .headlineSmall,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Therapy Type:",
                                                    style: darkTextTheme()
                                                        .headlineSmall,
                                                  ),
                                                  Text(
                                                    plan.sessions[i]
                                                        .standardOneType,
                                                    style: darkTextTheme()
                                                        .displaySmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    plan.sessions[i]
                                                        .standardOneIntensity,
                                                    style: darkTextTheme()
                                                        .headlineLarge,
                                                  ),
                                                  Text(
                                                    "Intensity",
                                                    style: darkTextTheme()
                                                        .headlineSmall,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    plan.sessions[i]
                                                        .passiveIntensity,
                                                    style: darkTextTheme()
                                                        .headlineLarge,
                                                  ),
                                                  Text(
                                                    "Intensity",
                                                    style: darkTextTheme()
                                                        .headlineSmall,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Therapy Type:",
                                                    style: darkTextTheme()
                                                        .headlineSmall,
                                                  ),
                                                  Text(
                                                    plan.sessions[i]
                                                        .standardTwoType,
                                                    style: darkTextTheme()
                                                        .displaySmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    plan.sessions[i]
                                                        .standardTwoIntensity,
                                                    style: darkTextTheme()
                                                        .headlineLarge,
                                                  ),
                                                  Text(
                                                    "Intensity",
                                                    style: darkTextTheme()
                                                        .headlineSmall,
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
            Align(
              alignment: Alignment.center,
              child: Theme(
                data: darkButtonTheme,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
