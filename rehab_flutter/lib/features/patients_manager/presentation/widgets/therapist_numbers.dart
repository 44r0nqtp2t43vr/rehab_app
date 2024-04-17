import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/therapist_number_card.dart';

class TherapistNumbers extends StatelessWidget {
  final Therapist therapist;

  const TherapistNumbers({super.key, required this.therapist});

  List<int> getNumbers() {
    final numbers = [0, 0];
    if (therapist.patients.isEmpty) {
      return numbers;
    }

    for (int i = 0; i < therapist.patients.length; i++) {
      final patientCurrentPlan = therapist.patients[i].getCurrentPlan();
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
    final therapistNumbers = getNumbers();

    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Expanded(
            child: TherapistNumberCard(
              number: therapist.patients.length,
              label: "Patients",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TherapistNumberCard(
              number: therapistNumbers[0],
              label: "With active plans",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TherapistNumberCard(
              number: therapistNumbers[1],
              label: "Without active plans",
            ),
          ),
        ],
      ),
    );
  }
}
