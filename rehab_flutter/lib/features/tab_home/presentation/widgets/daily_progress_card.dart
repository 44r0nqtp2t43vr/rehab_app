import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/features/passive_therapy/domain/models/passive_data.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';

class DailyProgressCard extends StatelessWidget {
  final Session todaySession;
  final bool isTherapistView;

  const DailyProgressCard({super.key, required this.todaySession, this.isTherapistView = false});

  @override
  Widget build(BuildContext context) {
    double percentCompletion = todaySession.sessionId.isEmpty ? 0 : todaySession.getTodayActivitiesPercentCompletion();

    return Container(
      height: 240,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Container(
            height: 136,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: CircularPercentIndicator(
                radius: 0.4 * 136,
                lineWidth: 10.0,
                percent: percentCompletion / 100,
                center: Text(
                  "${percentCompletion.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    fontFamily: "Sailec Bold",
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white,
                progressColor: const Color(0xff01FF99),
              ),
              // Text(
              //   "${todaySession == null ? 0 : todaySession!.getSessionPercentCompletion().toStringAsFixed(0)}%",
              //   style: const TextStyle(
              //     fontSize: 32,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
            ),
          ),
          const Spacer(),
          GlassContainer(
            blur: 10,
            color: Colors.white.withValues(alpha: 0.3),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onSeeDailyProgress(todaySession, context),
                child: Container(
                  height: 32,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      "Daily Progress",
                      style: darkTextTheme().headlineSmall,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSeeDailyProgress(Session session, BuildContext context) {
    if (session.sessionId.isEmpty) {
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/rise.svg',
                          width: MediaQuery.of(context).size.width * .06,
                          height: MediaQuery.of(context).size.height * .06,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Daily",
                                style: TextStyle(
                                  fontFamily: 'Sailec Bold',
                                  fontSize: 22,
                                  height: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Progress",
                                style: TextStyle(
                                  fontFamily: 'Sailec Light',
                                  fontSize: 16,
                                  height: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "${isTherapistView ? "This patient has" : "You have"} no sessions for today",
                      style: darkTextTheme().headlineMedium,
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
      final List<bool> conditions = session.getTodayActivitiesConditions();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/rise.svg',
                          width: MediaQuery.of(context).size.width * .06,
                          height: MediaQuery.of(context).size.height * .06,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Daily",
                                style: TextStyle(
                                  fontFamily: 'Sailec Bold',
                                  fontSize: 22,
                                  height: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Progress",
                                style: TextStyle(
                                  fontFamily: 'Sailec Light',
                                  fontSize: 16,
                                  height: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Radio(
                          value: conditions[0],
                          groupValue: true,
                          onChanged: (value) {},
                          fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                            return conditions[0] ? const Color(0xff01FF99) : Colors.white;
                          }),
                        ),
                        Expanded(
                          child: Text(
                            "Completed 1st Standard Session",
                            style: darkTextTheme().headlineSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Radio(
                          value: conditions[1],
                          groupValue: true,
                          onChanged: (value) {},
                          fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                            return conditions[1] ? const Color(0xff01FF99) : Colors.white;
                          }),
                        ),
                        Expanded(
                          child: Text(
                            "Completed Passive Session",
                            style: darkTextTheme().headlineSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Radio(
                          value: conditions[2],
                          groupValue: true,
                          onChanged: (value) {},
                          fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                            return conditions[2] ? const Color(0xff01FF99) : Colors.white;
                          }),
                        ),
                        Expanded(
                          child: Text(
                            "Completed 2nd Standard Session",
                            style: darkTextTheme().headlineSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Theme(
                    //       data: darkButtonTheme,
                    //       child: ElevatedButton(
                    //         onPressed: () => _onResetSessionPressed(context),
                    //         child: const Text('Debug: Reset Session'),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),
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
    }
  }

  void _onResetSessionPressed(BuildContext context) {
    final currentUser = BlocProvider.of<UserBloc>(context).state.currentUser!;
    final currentSession = BlocProvider.of<PatientCurrentSessionBloc>(context).state.currentSession!;

    BlocProvider.of<UserBloc>(context).add(ResetSessionEvent(PassiveData(user: currentUser, currentSession: currentSession)));
    Navigator.of(context).pop();
  }

  void _onCloseButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
