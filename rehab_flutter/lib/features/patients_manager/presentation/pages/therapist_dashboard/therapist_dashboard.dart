import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/patients_numbers/patients_numbers_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/patients_numbers/patients_numbers_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patient_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_progress_chart.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_numbers.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/welcome_card.dart';

class TherapistDashboard extends StatelessWidget {
  const TherapistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TherapistBloc, TherapistState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Column(
                children: [
                  WelcomeCard(
                    userFirstName: state.currentTherapist!.firstName.capitalize!,
                    userProfilePicture: state.currentTherapist!.imageURL,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Patient Statistics",
                      style: darkTextTheme().displaySmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<PatientNumbersBloc, PatientNumbersState>(
                    builder: (context, state) {
                      if (state is PatientNumbersLoading) {
                        return const Center(child: CupertinoActivityIndicator(color: Colors.white));
                      }
                      if (state is PatientNumbersDone) {
                        return PatientsNumbers(patientNumbers: state.patientNumbers);
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Patient Progress",
                      style: darkTextTheme().displaySmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<TherapistPatientListBloc, TherapistPatientListState>(
                    builder: (context, state) {
                      if (state is TherapistPatientListLoading) {
                        // return const Center(child: CupertinoActivityIndicator(color: Colors.white));
                        return PatientProgressChart(patients: state.therapistPatientList);
                      }
                      if (state is TherapistPatientListDone) {
                        return PatientProgressChart(patients: state.therapistPatientList);
                      }
                      return const SizedBox();
                    },
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
