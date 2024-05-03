import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_event.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/therapist_patient_operations.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patient_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/patient_page/patient_page_content.dart';

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
              } else if (state.operation == TherapistPatientOperation.addPlan) {
                BlocProvider.of<TherapistPatientListBloc>(context).add(UpdateTherapistPatientListEvent(state.patient!));
              }
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
                //CupertinoActivityIndicator(color: Colors.white),
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
