import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_state.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_details.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_plans_list.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/therapy_calendar.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_bloc.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/activity_chart_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/daily_progress_card.dart';
import 'package:rehab_flutter/features/tab_profile/presentation/widgets/profile_info_card.dart';

class PatientPageContent extends StatefulWidget {
  final AppUser patient;

  const PatientPageContent({super.key, required this.patient});

  @override
  State<PatientPageContent> createState() => _PatientPageContentState();
}

class _PatientPageContentState extends State<PatientPageContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TherapistBloc, TherapistState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        IconButton(
                          highlightColor: Colors.white.withOpacity(0.1),
                          icon: const Icon(
                            Icons.chevron_left,
                            size: 35,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: ProfileInfoCard(user: widget.patient),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Patient Details",
                        style: darkTextTheme().displaySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PatientDetails(patient: widget.patient),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Therapy Plans",
                        style: darkTextTheme().displaySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ViewedTherapistPatientPlansListBloc, ViewedTherapistPatientPlansListState>(
                      builder: (context, state) {
                        if (state is ViewedTherapistPatientPlansListLoading) {
                          return const Center(
                            child: CupertinoActivityIndicator(color: Colors.white),
                          );
                        }
                        if (state is ViewedTherapistPatientPlansListDone) {
                          final plansList = state.plansList;

                          return PatientPlansList(
                            patient: widget.patient,
                            plansList: plansList,
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 20),
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
                                    isTherapistView: true,
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
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Therapy Calendar",
                        style: darkTextTheme().displaySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<PatientPlansBloc, PatientPlansState>(
                      builder: (context, state) {
                        if (state is PatientPlansLoading) {
                          return const Center(
                            child: CupertinoActivityIndicator(color: Colors.white),
                          );
                        }
                        if (state is PatientPlansDone) {
                          return TherapyCalendar(sessions: state.plans.expand((plan) => plan.sessions).toList());
                        }
                        return Center(
                          child: Text(
                            "An error occurred while loading plans",
                            style: darkTextTheme().headlineSmall,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _onUnassignButtonPressed(
                              context,
                              state.currentTherapist!,
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff128BED)),
                              elevation: MaterialStateProperty.all<double>(0),
                              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.2)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            child: const Text("Unassign"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onUnassignButtonPressed(BuildContext context, Therapist therapist) {
    showDialog(
      context: context,
      barrierDismissible: true,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Are you sure?",
                        style: TextStyle(
                          fontFamily: 'Sailec Bold',
                          fontSize: 22,
                          height: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "This will remove the patient from your list",
                        style: TextStyle(
                          fontFamily: 'Sailec Light',
                          fontSize: 16,
                          height: 1.2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Theme(
                      data: darkButtonTheme,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<ViewedTherapistPatientBloc>(context).add(
                            AssignPatientEvent(
                                AssignPatientData(
                                  therapist: therapist,
                                  patientId: widget.patient.userId,
                                  isAssign: false,
                                ),
                                widget.patient),
                          );
                        },
                        child: const Text('Confirm'),
                      ),
                    ),
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
                        child: const Text('Cancel'),
                      ),
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
