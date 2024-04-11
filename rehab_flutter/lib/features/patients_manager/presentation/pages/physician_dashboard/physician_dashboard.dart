import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_list_card.dart';

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
        return Column(
          children: [
            Text(state.currentPhysician!.physicianId, style: const TextStyle(color: Colors.white)),
            state.currentPhysician!.patients.isEmpty
                ? const SizedBox()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.currentPhysician!.patients.length,
                    itemBuilder: (context, index) {
                      // Get the current patient
                      final patient = state.currentPhysician!.patients[index];
                      // Display the patient's ID
                      return PatientListCard(patient: patient);
                    },
                  ),
          ],
        );
      },
    );
  }
}
