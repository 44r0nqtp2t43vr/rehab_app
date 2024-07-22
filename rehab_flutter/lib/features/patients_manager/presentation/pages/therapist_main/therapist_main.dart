import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/patients_numbers/patients_numbers_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/patients_numbers/patients_numbers_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patient_list_sessions/therapist_patient_list_sessions_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patient_list_sessions/therapist_patient_list_sessions_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patient_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/therapist_dashboard/therapist_dashboard.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/therapist_patients/therapist_patients.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/therapist_profile/therapist_profile.dart';
import 'package:rehab_flutter/injection_container.dart';

class TherapistMainScreen extends StatelessWidget {
  const TherapistMainScreen({super.key});

  Widget getScreenFromTab(BuildContext context, TabEnum currentTab, Therapist currentTherapist) {
    switch (currentTab) {
      case TabEnum.home:
        if (BlocProvider.of<TherapistPatientListBloc>(context).state.therapistPatientList.isEmpty) {
          BlocProvider.of<TherapistPatientListBloc>(context).add(FetchTherapistPatientListEvent(currentTherapist.therapistId));
          BlocProvider.of<PatientNumbersBloc>(context).add(FetchPatientNumbersEvent(currentTherapist.patientsIds));
          BlocProvider.of<TherapistPatientListSessionsBloc>(context).add(FetchTherapistPatientListSessionsEvent(currentTherapist.patientsIds));
        }
        return const TherapistDashboard();
      case TabEnum.patients:
        return TherapistPatients(therapist: currentTherapist);
      case TabEnum.profile:
        return TherapistProfile(therapist: currentTherapist);
      default:
        return const TherapistDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<TherapistBloc, TherapistState>(
      listener: (BuildContext context, TherapistState state) {
        if (state is TherapistNone) {
          Navigator.of(context).pushReplacementNamed("/Login");
        }
      },
      builder: (context, state) {
        if (state is TherapistLoading) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        }
        if (state is TherapistDone) {
          return GetX<NavigationController>(
            builder: (_) {
              final currentTab = sl<NavigationController>().getTab();

              return Column(
                children: [
                  Expanded(
                    child: getScreenFromTab(context, currentTab, state.currentTherapist!),
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
                                    CupertinoIcons.calendar,
                                    size: 30,
                                    color: currentTab == TabEnum.patients ? Colors.white : const Color(0XFF93aac9),
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
              );
            },
          );
        }
        return Container();
      },
    );
  }

  void _onHomeButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.home) {
      sl<NavigationController>().setTab(TabEnum.home);
    }
  }

  void _onActivityButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.patients) {
      sl<NavigationController>().setTab(TabEnum.patients);
    }
  }

  void _onProfileButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.profile) {
      sl<NavigationController>().setTab(TabEnum.profile);
    }
  }
}
