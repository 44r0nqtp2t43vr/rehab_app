import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/therapist_patient_operations.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/patients_numbers/patients_numbers_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/patients_numbers/patients_numbers_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patient_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/patient_page/patient_page_content.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_bloc.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_event.dart';

class PatientPage extends StatelessWidget {
  const PatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ViewedTherapistPatientBloc, ViewedTherapistPatientState>(
          listenWhen: (previous, current) => previous is ViewedTherapistPatientLoading && current is ViewedTherapistPatientDone,
          listener: (context, state) {
            if (state is ViewedTherapistPatientDone) {
              if (state.operation! == TherapistPatientOperation.unassign) {
                BlocProvider.of<TherapistBloc>(context).add(GetTherapistEvent(state.therapist!));
                BlocProvider.of<TherapistPatientListBloc>(context).add(RemoveTherapistPatientListEvent(state.patient!));
                Navigator.of(context).pop();
              } else if (state.operation == TherapistPatientOperation.addPlan || state.operation == TherapistPatientOperation.deletePlan) {
                final userType = BlocProvider.of<UserBloc>(context).state;

                if (userType is UserNone && userType.data is Admin) {
                  // BlocProvider.of<ViewedPatientBloc>(context).add(AddPatientPlanEvent(AddPlanData(user: widget.patient, planSelected: int.parse(_weeksToAdd.text) * 7)));
                } else if (userType is UserNone && userType.data is Therapist) {
                  BlocProvider.of<PatientNumbersBloc>(context).add(FetchPatientNumbersEvent(userType.data.patientsIds));
                }

                BlocProvider.of<ViewedTherapistPatientPlansListBloc>(context).add(FetchViewedTherapistPatientPlansListEvent(state.patient!.userId));
                BlocProvider.of<PatientPlansBloc>(context).add(FetchPatientPlansEvent(state.patient!));
                BlocProvider.of<PatientCurrentPlanBloc>(context).add(FetchPatientCurrentPlanEvent(state.patient!));
                BlocProvider.of<PatientCurrentSessionBloc>(context).add(FetchPatientCurrentSessionEvent(state.patient!));
              }
              // else if (state.operation == TherapistPatientOperation.editSession) {
              //   BlocProvider.of<TherapistPatientListBloc>(context).add(UpdateTherapistPatientListEvent(state.patient!));
              //   Navigator.of(context).pushNamed("/PatientPlanDetails", arguments: PatientPlan(patient: state.patient!, plan: plan));
              // }
            }
          },
          builder: (context, state) {
            if (state is ViewedTherapistPatientLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/lotties/uploading.json',
                  width: 400,
                  height: 400,
                ),
              );
            }
            if (state is ViewedTherapistPatientDone) {
              return PatientPageContent(patient: state.patient!);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
