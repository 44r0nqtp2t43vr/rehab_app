import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_number_card.dart';

class AdminPatientsNumbers extends StatelessWidget {
  const AdminPatientsNumbers({super.key});

  List<int> getNumbers(List<AppUser> patients) {
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
    return BlocBuilder<PatientListBloc, PatientListState>(
      builder: (context, state) {
        if (state is PatientListLoading) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        }
        if (state is PatientListDone) {
          final patientNumbers = getNumbers(state.patientList);

          return SizedBox(
            height: 120,
            child: Row(
              children: [
                Expanded(
                  child: PatientsNumberCard(
                    number: state.patientList.length,
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
        return const SizedBox();
      },
    );
  }
}
