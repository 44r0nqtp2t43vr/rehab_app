import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_number_card.dart';

class PatientsNumbers extends StatelessWidget {
  final List<int> patientNumbers;

  const PatientsNumbers({super.key, required this.patientNumbers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Expanded(
            child: PatientsNumberCard(
              number: patientNumbers[0],
              label: "Patients",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PatientsNumberCard(
              number: patientNumbers[1],
              label: "With active plans",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PatientsNumberCard(
              number: patientNumbers[2],
              label: "Without active plans",
            ),
          ),
        ],
      ),
    );
  }
}
