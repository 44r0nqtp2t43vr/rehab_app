import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_state.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/patient_page/admin_patient_content.dart';

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
              BlocProvider.of<PatientListBloc>(context).add(UpdatePatientListEvent(state.patient!));
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
