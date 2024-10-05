import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_details.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_plans_list.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/therapy_calendar.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_bloc.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/activity_chart_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/daily_progress_card.dart';
import 'package:rehab_flutter/features/tab_profile/presentation/widgets/profile_info_card.dart';

class AdminPatientContent extends StatefulWidget {
  final AppUser patient;

  const AdminPatientContent({super.key, required this.patient});

  @override
  State<AdminPatientContent> createState() => _AdminPatientContentState();
}

class _AdminPatientContentState extends State<AdminPatientContent> {
  @override
  Widget build(BuildContext context) {
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
                        child: BlocConsumer<PatientPlansBloc, PatientPlansState>(
                          listener: (context, state) => setState(() {}),
                          builder: (context, state) {
                            if (state is PatientPlansLoading) {
                              return Container(
                                height: 240,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Center(child: CupertinoActivityIndicator(color: Colors.white)),
                              );
                            }

                            if (state is PatientPlansDone) {
                              return ActivityChartCard(plans: state.plans);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
