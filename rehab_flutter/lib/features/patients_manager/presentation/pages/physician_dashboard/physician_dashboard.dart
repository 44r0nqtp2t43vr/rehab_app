import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_progress_chart.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/physician_numbers.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/welcome_card.dart';

class PhysicianDashboard extends StatefulWidget {
  const PhysicianDashboard({super.key});

  @override
  State<PhysicianDashboard> createState() => _PhysicianDashboardState();
}

class _PhysicianDashboardState extends State<PhysicianDashboard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhysicianBloc, PhysicianState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Column(
                children: [
                  WelcomeCard(
                    userFirstName: state.currentPhysician!.firstName.capitalize!,
                    userProfilePicture: state.currentPhysician!.imageURL,
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
                  PhysicianNumbers(physician: state.currentPhysician!),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Patient Progress",
                      style: darkTextTheme().displaySmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PatientProgressChart(patients: state.currentPhysician!.patients),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
