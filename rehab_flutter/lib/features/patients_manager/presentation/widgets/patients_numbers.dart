import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_number_card.dart';

class PatientsNumbers extends StatelessWidget {
  final List<AppUser> patients;

  const PatientsNumbers({super.key, required this.patients});

  List<int> getNumbers() {
    final numbers = [0, 0];
    if (patients.isEmpty) {
      return numbers;
    }

    for (int i = 0; i < patients.length; i++) {
      final patientCurrentPlan = patients[i].getCurrentPlan();
      if (patientCurrentPlan == null) {
        numbers[1] = numbers[1] + 1;
      } else {
        numbers[0] = numbers[0] + 1;
      }
    }

    return numbers;
  }

  @override
  Widget build(BuildContext context) {
    final patientNumbers = getNumbers();

    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Expanded(
            child: PatientsNumberCard(
              number: patients.length,
              label: "Patients",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PatientsNumberCard(
              number: patientNumbers[0],
              label: "With active plans",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PatientsNumberCard(
              number: patientNumbers[1],
              label: "Without active plans",
            ),
          ),
        ],
      ),
    );
  }
}
