import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_progress_chart.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/therapist_numbers.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/welcome_card.dart';

class TherapistDashboard extends StatefulWidget {
  const TherapistDashboard({super.key});

  @override
  State<TherapistDashboard> createState() => _TherapistDashboardState();
}

class _TherapistDashboardState extends State<TherapistDashboard> {
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
                  TherapistNumbers(therapist: state.currentTherapist!),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Patient Progress",
                      style: darkTextTheme().displaySmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PatientProgressChart(patients: state.currentTherapist!.patients),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
