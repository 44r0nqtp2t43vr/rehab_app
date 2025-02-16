import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/session.dart';

class PatientsTherapySessionDetails extends StatelessWidget {
  final Session session;
  final String title;

  const PatientsTherapySessionDetails({super.key, required this.session, required this.title});

  @override
  Widget build(BuildContext context) {
    List<bool> conditions = session.getDayActivitiesConditions("");

    return GlassContainer(
      blur: 10,
      color: Colors.white.withValues(alpha: 0.3),
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
                                        color: Colors.white.withValues(alpha: 0.25),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                // session.pretestScore!.toStringAsFixed(1),
                                                "no score",
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
                                        color: Colors.white.withValues(alpha: 0.25),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                // !conditions[4] ? '0' : session.posttestScore!.toStringAsFixed(1),
                                                "no score",
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
                                      color: Colors.white.withValues(alpha: 0.25),
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
                                                    // session.standardOneType,
                                                    "no type",
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
                                                    // session.standardOneIntensity,
                                                    "no intensity",
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
                                      "Passive Therapy",
                                      style: darkTextTheme().displaySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    GlassContainer(
                                      shadowStrength: 1,
                                      shadowColor: Colors.black,
                                      blur: 4,
                                      color: Colors.white.withValues(alpha: 0.25),
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
                                                    // session.passiveIntensity,
                                                    "no intensity",
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
                                      color: Colors.white.withValues(alpha: 0.25),
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
                                                    // session.standardTwoType,
                                                    "no type",
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
                                                    // session.standardTwoIntensity,
                                                    "no intensity",
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
