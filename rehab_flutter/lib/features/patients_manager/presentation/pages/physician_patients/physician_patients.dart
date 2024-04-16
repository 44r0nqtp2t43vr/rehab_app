import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_list_card.dart';

class PhysicianPatients extends StatelessWidget {
  const PhysicianPatients({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhysicianBloc, PhysicianState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Patients",
                          style: darkTextTheme().headlineLarge,
                        ),
                        Text(
                          "Your Assigned Patients",
                          style: darkTextTheme().headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  state.currentPhysician!.patients.isEmpty
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Sort by:',
                              style: darkTextTheme().headlineSmall,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff128BED),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'DROPDOWN',
                                      style: darkTextTheme().displaySmall,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      CupertinoIcons.arrowtriangle_down_fill,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 16),
                  state.currentPhysician!.patients.isEmpty
                      ? const Text("You have no assigned patients",
                          style: TextStyle(color: Colors.white))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.currentPhysician!.patients.length,
                          itemBuilder: (context, index) {
                            // Get the current patient
                            final patient =
                                state.currentPhysician!.patients[index];
                            // Display the patient's ID
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: PatientListCard(patient: patient),
                            );
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
