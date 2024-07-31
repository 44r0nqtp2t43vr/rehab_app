import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_number_card.dart';

class TherapistsNumbers extends StatelessWidget {
  const TherapistsNumbers({super.key});

  List<int> getNumbers(List<Therapist> therapists) {
    final numbers = [0, 0];
    if (therapists.isEmpty) {
      return numbers;
    }

    for (int i = 0; i < therapists.length; i++) {
      final numberOfPatients = therapists[i].patientsIds.length;
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
    return BlocBuilder<TherapistListBloc, TherapistListState>(
      builder: (context, state) {
        if (state is TherapistListLoading) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        }
        if (state is TherapistListDone) {
          final therapistNumbers = getNumbers(state.therapistList);

          return SizedBox(
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: PatientsNumberCard(
                    number: state.therapistList.length,
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
        return const SizedBox();
      },
    );
  }
}
