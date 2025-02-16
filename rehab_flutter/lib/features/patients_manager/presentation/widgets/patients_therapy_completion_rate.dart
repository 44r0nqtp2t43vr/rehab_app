import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_state.dart';

class PatientsTherapyCompletionRate extends StatelessWidget {
  const PatientsTherapyCompletionRate({super.key});

  double getPlanPercentCompletion(List<Session> sessions) {
    double percent = 0;
    for (var session in sessions) {
      percent += session.getSessionPercentCompletion();
    }
    return percent / sessions.length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewedTherapistPatientPlanSessionsListBloc, ViewedTherapistPatientPlanSessionsListState>(
      builder: (context, state) {
        if (state is ViewedTherapistPatientPlanSessionsListLoading) {
          return Expanded(
            child: Center(
              child: CupertinoActivityIndicator(color: Colors.white),
            ),
          );
        }
        if (state is ViewedTherapistPatientPlanSessionsListDone) {
          return Expanded(
            child: GlassContainer(
              shadowStrength: 2,
              // shadowColor: Colors.black,
              blur: 4,
              color: Colors.white.withValues(alpha: 0.25),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 0.4 * 136,
                      lineWidth: 10.0,
                      percent: getPlanPercentCompletion(state.sessionsList) / 100,
                      center: Text(
                        "${getPlanPercentCompletion(state.sessionsList).toStringAsFixed(2)}%",
                        style: const TextStyle(
                          fontFamily: "Sailec Bold",
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.white,
                      progressColor: const Color(0xff01FF99),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Therapy Plan Completion Rate",
                      style: darkTextTheme().headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
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
