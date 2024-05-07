import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/passive_therapy_data.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_therapy_data.dart';

class ContinueCard extends StatelessWidget {
  final AppUser user;

  const ContinueCard({super.key, required this.user});

  // void _selectPlan(BuildContext context, String planName, AppUser user) {
  //   int daysToAdd;
  //   switch (planName) {
  //     case 'One Week':
  //       daysToAdd = 7;
  //       break;
  //     case 'One Month':
  //       daysToAdd = 30;
  //       break;
  //     case 'Three Months':
  //       daysToAdd = 90;
  //       break;
  //     default:
  //       daysToAdd = 7;
  //   }
  //   Navigator.of(context).pop();
  //   BlocProvider.of<UserBloc>(context).add(AddPlanEvent(AddPlanData(user: user, planSelected: daysToAdd)));
  // }

  @override
  Widget build(BuildContext context) {
    final Plan? currentPlan = user.getCurrentPlan();

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
                  color: Colors.black.withOpacity(0.15),
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
                    color: Colors.black.withOpacity(0.2),
                  ),
                  Positioned(
                    left: -30,
                    child: Text(
                      '%',
                      style: TextStyle(
                        fontFamily: 'Sailec Bold',
                        fontSize: 150,
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "${currentPlan == null ? 0 : currentPlan.getPlanPercentCompletion().toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontFamily: 'Sailec Bold',
                            fontSize: 48,
                            color: Colors.white,
                          ),
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
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              highlightColor: Colors.white.withOpacity(0.2),
              onTap: () => _onTap(context, user, currentPlan),
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context, AppUser user, Plan? currentPlan) {
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
              color: Colors.white.withOpacity(0.3),
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
      Session? currentSession = currentPlan.getCurrentSession();
      if (currentSession == null) {
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
        List<bool> conditions = currentSession.getSessionConditions();
        if (!conditions[0]) {
          Navigator.pushNamed(context, '/Testing', arguments: true);
        } else if (!conditions[1]) {
          Navigator.pushNamed(
            context,
            '/StandardTherapy',
            arguments: StandardTherapyData(
              userId: user.userId,
              isStandardOne: true,
              type: currentSession.getStandardOneType(),
              intensity: int.parse(currentSession.standardOneIntensity),
            ),
          );
        } else if (!conditions[2]) {
          Navigator.pushNamed(context, '/PassiveTherapy',
              arguments: PassiveTherapyData(
                userId: user.userId,
                intensity: int.parse(currentSession.passiveIntensity),
              ));
        } else if (!conditions[3]) {
          Navigator.pushNamed(
            context,
            '/StandardTherapy',
            arguments: StandardTherapyData(
              userId: user.userId,
              isStandardOne: false,
              type: currentSession.getStandardTwoType(),
              intensity: int.parse(currentSession.standardTwoIntensity),
            ),
          );
        } else if (!conditions[4]) {
          Navigator.pushNamed(context, '/Testing', arguments: false);
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
                  color: Colors.white.withOpacity(0.3),
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
