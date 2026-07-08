import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/passive_therapy_data.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_therapy_data.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_state.dart';

class ContinueCard extends StatelessWidget {
  final AppUser user;
  final Session session;

  const ContinueCard({super.key, required this.user, required this.session});

  @override
  Widget build(BuildContext context) {
    // final Plan? currentPlan = user.getCurrentPlan();

    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF128BED),
                          Color(0xFF01FF99),
                        ],
                        stops: [0.3, 1.0],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                  Positioned(
                    left: -30,
                    child: Text(
                      '%',
                      style: TextStyle(
                        fontFamily: 'Sailec Bold',
                        fontSize: 150,
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: BlocBuilder<PatientCurrentPlanBloc, PatientCurrentPlanState>(
                          builder: (context, state) {
                            if (state is PatientCurrentPlanLoading) {
                              return const Center(child: CupertinoActivityIndicator(color: Colors.white));
                            }

                            if (state is PatientCurrentPlanDone) {
                              final currentPlan = state.currentPlan!;

                              return Text(
                                "${currentPlan.planId == Plan.empty().planId ? 0 : currentPlan.getPlanPercentCompletion().toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontFamily: 'Sailec Bold',
                                  fontSize: 48,
                                  color: Colors.white,
                                ),
                              );
                            }

                            return const Text(
                              "0",
                              style: TextStyle(
                                fontFamily: 'Sailec Bold',
                                fontSize: 48,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CONTINUE",
                              style: TextStyle(
                                fontFamily: 'Sailec Light',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Therapy Plan",
                              style: TextStyle(
                                fontFamily: 'Sailec Bold',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Overall Progress",
                              style: TextStyle(
                                fontFamily: 'Sailec Light',
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: BlocBuilder<PatientCurrentPlanBloc, PatientCurrentPlanState>(
              builder: (context, state) {
                if (state is PatientCurrentPlanDone) {
                  final currentPlan = state.currentPlan!;

                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    highlightColor: Colors.white.withValues(alpha: 0.2),
                    onTap: () => _onTap(context, user, currentPlan, session),
                    child: Container(),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context, AppUser user, Plan? currentPlan, Session session) {
    if (currentPlan == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            content: GlassContainer(
              blur: 10,
              color: Colors.white.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Row(
                      children: [
                        Icon(CupertinoIcons.exclamationmark_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "No active plan",
                            style: TextStyle(
                              fontFamily: 'Sailec Bold',
                              fontSize: 22,
                              height: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Please consult your therapist to create your therapy plan",
                      style: darkTextTheme().headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Theme(
                          data: darkButtonTheme,
                          child: ElevatedButton(
                            onPressed: () => _onCloseButtonPressed(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      final todayActivities = session.getTodayActivities();
      if (todayActivities == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    "You have no sessions for today",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () => _onCloseButtonPressed(context),
                    child: const Text("CLOSE"),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        List<bool> conditions = session.getTodayActivitiesConditions();
        // pretest
        // Navigator.pushNamed(context, '/Testing', arguments: true);
        // posttest
        // Navigator.pushNamed(context, '/Testing', arguments: false);
        if (!conditions[0]) {
          Navigator.pushNamed(
            context,
            '/StandardTherapy',
            arguments: StandardTherapyData(
              userId: user.userId,
              isStandardOne: true,
              type: session.getStandardOneType(todayActivities),
              intensity: session.getStandardOneIntensity(todayActivities),
            ),
          );
        } else if (!conditions[1]) {
          Navigator.pushNamed(context, '/PassiveTherapy',
              arguments: PassiveTherapyData(
                user: user,
                intensity: session.getStandardOneIntensity(todayActivities),
              ));
        } else if (!conditions[2]) {
          Navigator.pushNamed(
            context,
            '/StandardTherapy',
            arguments: StandardTherapyData(
              userId: user.userId,
              isStandardOne: false,
              type: session.getStandardTwoType(todayActivities),
              intensity: session.getStandardTwoIntensity(todayActivities),
            ),
          );
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                content: GlassContainer(
                  blur: 10,
                  color: Colors.white.withValues(alpha: 0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "You have completed all Sessions for today.",
                          textAlign: TextAlign.center,
                          style: darkTextTheme().headlineMedium,
                        ),
                        const SizedBox(height: 28),
                        Theme(
                          data: darkButtonTheme,
                          child: ElevatedButton(
                            onPressed: () => _onCloseButtonPressed(context),
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      }
    }
  }

  void _onCloseButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
