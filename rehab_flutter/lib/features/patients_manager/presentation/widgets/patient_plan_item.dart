import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/delete_plan_data.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan/viewed_therapist_patient_plan_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan/viewed_therapist_patient_plan_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_event.dart';

class PatientPlanItem extends StatelessWidget {
  final PatientPlan patientPlan;
  final int planNo;
  final bool isCurrent;
  final String onPressedRoute;

  const PatientPlanItem({super.key, required this.patientPlan, required this.planNo, required this.isCurrent, required this.onPressedRoute});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      onTap: () => _onPatientCardPressed(context),
      child: GlassContainer(
        shadowStrength: 2,
        shadowColor: Colors.black,
        blur: 4,
        color: isCurrent ? const Color(0xff01FF99).withOpacity(0.25) : Colors.white.withOpacity(0.25),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    "$planNo",
                    style: darkTextTheme().headlineSmall,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${DateFormat('MMMM dd, yyyy').format(patientPlan.plan.startDate)} - ${DateFormat('MMMM dd, yyyy').format(patientPlan.plan.endDate)}",
                  style: darkTextTheme().headlineSmall,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _onPlanDeletePressed(context),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPatientCardPressed(BuildContext context) {
    BlocProvider.of<ViewedTherapistPatientPlanBloc>(context).add(UpdateTherapistPatientPlanEvent(patientPlan.plan, patientPlan.patient));
    BlocProvider.of<ViewedTherapistPatientPlanSessionsListBloc>(context).add(FetchViewedTherapistPatientPlanSessionsListEvent(patientPlan.plan, patientPlan.patient));
    Navigator.of(context).pushNamed(onPressedRoute);
  }

  void _onPlanDeletePressed(BuildContext context) {
    BlocProvider.of<ViewedTherapistPatientBloc>(context).add(DeleteTherapistPatientPlanEvent(DeletePlanData(user: patientPlan.patient, planIdToDelete: patientPlan.plan.planId)));
  }
}
