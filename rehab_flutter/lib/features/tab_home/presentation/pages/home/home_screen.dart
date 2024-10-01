import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_bloc.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_event.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/activity_chart_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/continue_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/daily_progress_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/mini_calendar.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/take_test_button.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/welcome_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime focusedDay = DateTime.now();

  Future<void> _refreshData() async {
    final currentUser = BlocProvider.of<UserBloc>(context).state.currentUser!;

    BlocProvider.of<PatientPlansBloc>(context).add(FetchPatientPlansEvent(currentUser));
    BlocProvider.of<PatientCurrentPlanBloc>(context).add(FetchPatientCurrentPlanEvent(currentUser));
    BlocProvider.of<PatientCurrentSessionBloc>(context).add(FetchPatientCurrentSessionEvent(currentUser));
  }

  void _onCalendarPageChanged(DateTime newDate) {
    setState(() {
      focusedDay = newDate;
    });
  }

  Map<String, Color?> getDateColorsMapFromPlans(List<Plan> plans) {
    Map<String, Color?> dateColorsMap = {};
    // List<Session> sessions = plans.expand((plan) => plan.sessions).toList();

    // for (var sesh in sessions) {
    //   final String dateString = "${sesh.date.year}${sesh.date.month}${sesh.date.day}";
    //   final List<bool> conditions = sesh.getSessionConditions();

    //   if (conditions[0] && conditions[1] && conditions[2] && conditions[3] && conditions[4]) {
    //     dateColorsMap[dateString] = heatmap5;
    //   } else if (conditions[0] && conditions[1] && conditions[2] && conditions[3]) {
    //     dateColorsMap[dateString] = heatmap4;
    //   } else if (conditions[0] && conditions[1] && conditions[2]) {
    //     dateColorsMap[dateString] = heatmap3;
    //   } else if (conditions[0] && conditions[1]) {
    //     dateColorsMap[dateString] = heatmap2;
    //   } else if (conditions[0]) {
    //     dateColorsMap[dateString] = heatmap1;
    //   } else {
    //     dateColorsMap[dateString] = null;
    //   }
    // }

    return dateColorsMap;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserDone) {
          final patient = state.currentUser!;

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WelcomeCard(
                        userFirstName: state.currentUser!.firstName,
                        userProfilePicture: state.currentUser!.imageURL,
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<PatientCurrentSessionBloc, PatientCurrentSessionState>(
                        builder: (context, state) {
                          if (state is PatientCurrentSessionLoading) {
                            return const Center(child: CupertinoActivityIndicator(color: Colors.white));
                          }

                          if (state is PatientCurrentSessionDone) {
                            final currentSession = state.currentSession!;

                            return Column(
                              children: [
                                currentSession.testingItems.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: TakeTestButton(),
                                      )
                                    : const SizedBox(),
                                ContinueCard(
                                  user: patient,
                                  session: state.currentSession!,
                                ),
                              ],
                            );
                          }

                          return Center(
                            child: Text(
                              "An error occurred while loading current session",
                              textAlign: TextAlign.center,
                              style: darkTextTheme().headlineSmall,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Today's Activity",
                          style: darkTextTheme().displaySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: GlassContainer(
                              shadowStrength: 2,
                              shadowColor: Colors.black,
                              blur: 4,
                              color: Colors.white.withOpacity(0.25),
                              child: BlocConsumer<PatientCurrentSessionBloc, PatientCurrentSessionState>(
                                listener: (context, state) => setState(() {}),
                                builder: (context, state) {
                                  if (state is PatientCurrentSessionLoading) {
                                    return Container(
                                      height: 240,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: const Center(child: CupertinoActivityIndicator(color: Colors.white)),
                                    );
                                  }

                                  if (state is PatientCurrentSessionDone) {
                                    return DailyProgressCard(
                                      todaySession: state.currentSession!,
                                    );
                                  }

                                  return Container(
                                    height: 240,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "An error occurred while loading current session",
                                        textAlign: TextAlign.center,
                                        style: darkTextTheme().headlineSmall,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 5,
                            child: GlassContainer(
                              shadowStrength: 2,
                              shadowColor: Colors.black,
                              blur: 4,
                              color: Colors.white.withOpacity(0.25),
                              child: BlocConsumer<PatientCurrentPlanBloc, PatientCurrentPlanState>(
                                listener: (context, state) => setState(() {}),
                                builder: (context, state) {
                                  if (state is PatientCurrentPlanLoading) {
                                    return Container(
                                      height: 240,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: const Center(child: CupertinoActivityIndicator(color: Colors.white)),
                                    );
                                  }

                                  if (state is PatientCurrentPlanDone) {
                                    return ActivityChartCard(currentPlan: state.currentPlan);
                                  }

                                  return Container(
                                    height: 240,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "An error occurred while loading current plan",
                                        textAlign: TextAlign.center,
                                        style: darkTextTheme().headlineSmall,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Text(
                            "Activity Monitor",
                            style: darkTextTheme().displaySmall,
                          ),
                          const Spacer(),
                          BlocBuilder<PatientPlansBloc, PatientPlansState>(
                            builder: (context, state) {
                              if (state is PatientPlansDone) {
                                return Text(
                                  "${getMonth(focusedDay.month)} ${focusedDay.year}",
                                  style: const TextStyle(
                                    fontFamily: "Sailec Medium",
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      BlocConsumer<PatientPlansBloc, PatientPlansState>(
                        listener: (context, state) => setState(() {}),
                        builder: (context, state) {
                          if (state is PatientPlansLoading) {
                            return const Center(
                              child: CupertinoActivityIndicator(color: Colors.white),
                            );
                          }
                          if (state is PatientPlansDone) {
                            return MiniCalendar(
                              user: null,
                              dateColorsMap: getDateColorsMapFromPlans(state.plans),
                              focusedDay: focusedDay,
                              onPageChanged: _onCalendarPageChanged,
                            );
                          }
                          return Center(
                            child: Text(
                              "An error occurred while loading plans",
                              style: darkTextTheme().headlineSmall,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
