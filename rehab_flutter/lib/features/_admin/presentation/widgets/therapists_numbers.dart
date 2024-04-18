import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_number_card.dart';

class TherapistsNumbers extends StatelessWidget {
  final List<Therapist> therapists;

  const TherapistsNumbers({super.key, required this.therapists});

  List<int> getNumbers() {
    final numbers = [0, 0];
    if (therapists.isEmpty) {
      return numbers;
    }

    for (int i = 0; i < therapists.length; i++) {
      final numberOfPatients = therapists[i].patients.length;
      if (numberOfPatients == 0) {
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
            child: PatientsNumberCard(
              number: therapists.length,
              label: "Therapists",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PatientsNumberCard(
              number: therapistNumbers[0],
              label: "With assigned patients",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: PatientsNumberCard(
              number: therapistNumbers[1],
              label: "Without assigned patients",
            ),
          ),
        ],
      ),
    );
  }
}
