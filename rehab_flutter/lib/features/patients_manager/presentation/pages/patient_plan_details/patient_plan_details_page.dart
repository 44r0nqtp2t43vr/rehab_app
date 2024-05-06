import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patient_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan/viewed_therapist_patient_plan_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan/viewed_therapist_patient_plan_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/patient_plan_details/patient_plan_details_content.dart';

class PatientPlanDetailsPage extends StatelessWidget {
  const PatientPlanDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ViewedTherapistPatientPlanBloc, ViewedTherapistPatientPlanState>(
          listenWhen: (previous, current) => previous is ViewedTherapistPatientPlanLoading && current is ViewedTherapistPatientPlanDone,
          listener: (context, state) {
            if (state is ViewedTherapistPatientPlanDone) {
              BlocProvider.of<TherapistPatientListBloc>(context).add(UpdateTherapistPatientListEvent(state.data));
              BlocProvider.of<ViewedTherapistPatientBloc>(context).add(UpdateViewedTherapistPatientEvent(state.data));
            }
          },
          builder: (context, state) {
            if (state is ViewedTherapistPatientPlanLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/lotties/uploading.json',
                  width: 400,
                  height: 400,
                ),
              );
            }
            if (state is ViewedTherapistPatientPlanDone) {
              return PatientPlanDetails(patientPlan: PatientPlan(patient: state.data, plan: state.plan!));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
