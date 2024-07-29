import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/admin_patient_numbers/admin_patient_numbers_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/admin_patient_numbers/admin_patient_numbers_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_state.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/patient_page/admin_patient_content.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_event.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_bloc.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_event.dart';

class AdminPatientPage extends StatelessWidget {
  const AdminPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ViewedPatientBloc, ViewedPatientState>(
          listenWhen: (previous, current) => previous is ViewedPatientLoading && current is ViewedPatientDone,
          listener: (context, state) {
            if (state is ViewedPatientDone) {
              BlocProvider.of<ViewedTherapistPatientPlansListBloc>(context).add(FetchViewedTherapistPatientPlansListEvent(state.patient!.userId));
              BlocProvider.of<AdminPatientNumbersBloc>(context).add(const FetchAdminPatientNumbersEvent());
              BlocProvider.of<PatientPlansBloc>(context).add(FetchPatientPlansEvent(state.patient!));
              BlocProvider.of<PatientCurrentPlanBloc>(context).add(FetchPatientCurrentPlanEvent(state.patient!));
              BlocProvider.of<PatientCurrentSessionBloc>(context).add(FetchPatientCurrentSessionEvent(state.patient!));
            }
          },
          builder: (context, state) {
            if (state is ViewedPatientLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/lotties/uploading.json',
                  width: 400,
                  height: 400,
                ),
              );
            }
            if (state is ViewedPatientDone) {
              return AdminPatientContent(patient: state.patient!);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
