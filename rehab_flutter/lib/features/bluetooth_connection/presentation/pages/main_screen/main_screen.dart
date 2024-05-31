import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_bloc.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_event.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_state.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/pages/activity_monitor/activity_monitor.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/pages/home/home_screen.dart';
import 'package:rehab_flutter/features/tab_profile/presentation/pages/profile/profile_screen.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/pages/therapy/therapy_screen.dart';
import 'package:rehab_flutter/injection_container.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Widget getScreenFromTab(BuildContext context, TabEnum currentTab, AppUser user) {
    switch (currentTab) {
      case TabEnum.home:
        // if (BlocProvider.of<PatientPlansBloc>(context).state.plans.isEmpty) {
        //   BlocProvider.of<PatientPlansBloc>(context).add(FetchPatientPlansEvent(user));
        // }

        // if (BlocProvider.of<PatientCurrentPlanBloc>(context).state.currentPlan == null) {
        //   BlocProvider.of<PatientCurrentPlanBloc>(context).add(FetchPatientCurrentPlanEvent(user));
        // }

        // if (BlocProvider.of<PatientCurrentSessionBloc>(context).state.currentSession == null) {
        //   BlocProvider.of<PatientCurrentSessionBloc>(context).add(FetchPatientCurrentSessionEvent(user));
        // }

        return const HomeScreen();
      case TabEnum.therapy:
        return const TherapyScreen();
      case TabEnum.activityMonitor:
        return BlocBuilder<PatientPlansBloc, PatientPlansState>(
          builder: (context, state) {
            if (state is PatientPlansLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/lotties/loading-1.json',
                  width: 400,
                  height: 400,
                ),
              );
            }
            if (state is PatientPlansDone) {
              return ActivityMonitor(sessions: state.plans.expand((plan) => plan.sessions).toList());
            }
            return Center(
              child: Text(
                "An error occurred while loading plans",
                style: darkTextTheme().headlineSmall,
              ),
            );
          },
        );
      case TabEnum.profile:
        return ProfileScreen(user: user);
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (BuildContext context, UserState state) {
        if (state is UserNone) {
          Navigator.of(context).pushReplacementNamed("/Login");
        }
        if (state is UserDone) {
          final currentSession = state.currentSession;

          if (currentSession != null) {
            final patientPlans = BlocProvider.of<PatientPlansBloc>(context).state.plans;
            final currentPlan = BlocProvider.of<PatientCurrentPlanBloc>(context).state.currentPlan!;

            BlocProvider.of<PatientPlansBloc>(context).add(UpdatePatientPlansEvent(patientPlans, currentSession));
            BlocProvider.of<PatientCurrentSessionBloc>(context).add(UpdateCurrentSessionEvent(currentSession));
            BlocProvider.of<PatientCurrentPlanBloc>(context).add(UpdateCurrentPlanSessionEvent(currentPlan, currentSession));
          }
        }
      },
      builder: (BuildContext context, UserState state) {
        if (state is UserLoading) {
          return Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lotties/loading-1.json',
                width: 400,
                height: 400,
              ),
              //CupertinoActivityIndicator(color: Colors.white),
            ),
          );
        }
        if (state is UserDone) {
          return GetX<NavigationController>(
            builder: (_) {
              final currentTab = sl<NavigationController>().getTab();
              final currentTabTherapy = sl<NavigationController>().getTherapyTab();

              return PopScope(
                canPop: false,
                onPopInvoked: (didPop) {
                  if (didPop) {
                    return;
                  }

                  if (currentTab == TabEnum.therapy && currentTabTherapy == TabTherapyEnum.music) {
                    sl<NavigationController>().setTherapyTab(TabTherapyEnum.home);
                  } else if (currentTab == TabEnum.therapy && currentTabTherapy == TabTherapyEnum.specificGenre) {
                    sl<NavigationController>().setTherapyTab(TabTherapyEnum.music);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: getScreenFromTab(context, currentTab, state.currentUser!),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        highlightColor: Colors.white.withOpacity(0.1),
                                        icon: Icon(
                                          currentTab == TabEnum.home ? CupertinoIcons.house_fill : CupertinoIcons.house,
                                          size: 30,
                                          color: currentTab == TabEnum.home ? Colors.white : const Color(0XFF93aac9),
                                        ),
                                        onPressed: () => _onHomeButtonPressed(currentTab),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        highlightColor: Colors.white.withOpacity(0.1),
                                        icon: Icon(
                                          currentTab == TabEnum.therapy ? CupertinoIcons.circle_grid_3x3_fill : CupertinoIcons.circle_grid_3x3,
                                          size: 30,
                                          color: currentTab == TabEnum.therapy ? Colors.white : const Color(0XFF93aac9),
                                        ),
                                        onPressed: () => _onTherapyButtonPressed(currentTab),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        highlightColor: Colors.white.withOpacity(0.1),
                                        icon: Icon(
                                          CupertinoIcons.calendar,
                                          size: 30,
                                          color: currentTab == TabEnum.activityMonitor ? Colors.white : const Color(0XFF93aac9),
                                        ),
                                        onPressed: () => _onActivityButtonPressed(currentTab),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        highlightColor: Colors.white.withOpacity(0.1),
                                        icon: Icon(
                                          currentTab == TabEnum.profile ? CupertinoIcons.person_fill : CupertinoIcons.person,
                                          size: 30,
                                          color: currentTab == TabEnum.profile ? Colors.white : const Color(0XFF93aac9),
                                        ),
                                        onPressed: () => _onProfileButtonPressed(currentTab),
                                      ),
                                    ),
                                  ],
                                ),
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
        return const SizedBox();
      },
    );
  }

  void _onHomeButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.home) {
      sl<NavigationController>().setTab(TabEnum.home);
    }
  }

  void _onTherapyButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.therapy) {
      sl<NavigationController>().setTab(TabEnum.therapy);
      sl<NavigationController>().setTherapyTab(TabTherapyEnum.home);
    }
  }

  void _onActivityButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.activityMonitor) {
      sl<NavigationController>().setTab(TabEnum.activityMonitor);
    }
  }

  void _onProfileButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.profile) {
      sl<NavigationController>().setTab(TabEnum.profile);
    }
  }
}
