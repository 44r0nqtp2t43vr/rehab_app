import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
// import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
// import 'package:rehab_flutter/core/entities/plan.dart';
// import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_event.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_bloc.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_event.dart';

class PatientListCard extends StatelessWidget {
  final AppUser patient;
  final String onPressedRoute;

  const PatientListCard({super.key, required this.patient, required this.onPressedRoute});

  @override
  Widget build(BuildContext context) {
    // final Plan? currentPlan = patient.getCurrentPlan();
    // final Session? currentSession = patient.getCurrentSession();

    return InkWell(
      highlightColor: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(10),
      onTap: () => _onPatientCardPressed(context),
      child: GlassContainer(
        shadowStrength: 2,
        // shadowColor: Colors.black,
        blur: 4,
        color: Colors.white.withValues(alpha: 0.25),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xffd1d1d1),
                    radius: 32,
                    child: patient.imageURL != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: patient.imageURL!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                            // Image.network(
                            //   patient.imageURL!,
                            //   fit: BoxFit.cover,
                            //   width: double.infinity,
                            //   height: double.infinity,
                            // ),
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                CupertinoIcons.profile_circled,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ),
                  ),
                  // const SizedBox(height: 12),
                  // Row(
                  //   children: [
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         const Text(
                  //           "Daily",
                  //           style: TextStyle(
                  //             fontFamily: 'Sailec Light',
                  //             fontSize: 8,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${currentSession == null ? 0 : currentSession.getSessionPercentCompletion().toStringAsFixed(0)}",
                  //           style: const TextStyle(
                  //             fontFamily: 'Sailec Bold',
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         const Text(
                  //           "Overall",
                  //           style: TextStyle(
                  //             fontFamily: 'Sailec Light',
                  //             fontSize: 8,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${currentPlan == null ? 0 : currentPlan.getPlanPercentCompletion().toStringAsFixed(0)}",
                  //           style: const TextStyle(
                  //             fontFamily: 'Sailec Bold',
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 64,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${patient.firstName.capitalize!} ${patient.lastName.capitalize!}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Sailec Bold',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  patient.email,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: darkTextTheme().headlineSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   "Current Plan: ${currentPlan == null ? "None" : "${DateFormat('MMMM dd, yyyy').format(currentPlan.startDate)}-${DateFormat('MMMM dd, yyyy').format(currentPlan.endDate)} - Plan #${patient.plans.indexWhere((plan) => plan.startDate.month == currentPlan.startDate.month && plan.startDate.day == currentPlan.startDate.day && plan.startDate.year == currentPlan.startDate.year) + 1}"}",
                    //   style: const TextStyle(
                    //     fontFamily: 'Sailec Light',
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    // Text(
                    //   "Current Session: ${currentSession == null ? "None" : "${DateFormat('MMMM dd, yyyy').format(currentSession.date)} - ${currentPlan!.sessions.indexWhere((session) => session.date.month == currentSession.date.month && session.date.day == currentSession.date.day && session.date.year == currentSession.date.year) + 1}/${currentPlan.sessions.length}"}",
                    //   style: const TextStyle(
                    //     fontFamily: 'Sailec Light',
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPatientCardPressed(BuildContext context) {
    BlocProvider.of<ViewedTherapistPatientBloc>(context).add(FetchViewedTherapistPatientEvent(patient));
    BlocProvider.of<ViewedTherapistPatientPlansListBloc>(context).add(FetchViewedTherapistPatientPlansListEvent(patient.userId));
    BlocProvider.of<PatientPlansBloc>(context).add(FetchPatientPlansEvent(patient));
    BlocProvider.of<PatientCurrentPlanBloc>(context).add(FetchPatientCurrentPlanEvent(patient));
    BlocProvider.of<PatientCurrentSessionBloc>(context).add(FetchPatientCurrentSessionEvent(patient));

    Navigator.of(context).pushNamed(onPressedRoute);
  }
}
