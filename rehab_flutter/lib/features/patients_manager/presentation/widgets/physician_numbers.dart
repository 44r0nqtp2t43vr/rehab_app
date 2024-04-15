import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/physician_number_card.dart';

class PhysicianNumbers extends StatelessWidget {
  final Physician physician;

  const PhysicianNumbers({super.key, required this.physician});

  List<int> getNumbers() {
    final numbers = [0, 0];
    if (physician.patients.isEmpty) {
      return numbers;
    }

    for (int i = 0; i < physician.patients.length; i++) {
      final patientCurrentPlan = physician.patients[i].getCurrentPlan();
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
    final physicianNumbers = getNumbers();

    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Expanded(
            child: PhysicianNumberCard(
              number: physician.patients.length,
              label: "Patients",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PhysicianNumberCard(
              number: physicianNumbers[0],
              label: "With active plans",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PhysicianNumberCard(
              number: physicianNumbers[1],
              label: "Without active plans",
            ),
          ),
        ],
      ),
    );
  }
}
