import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_state.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/admin_patient_list_card.dart';

class AdminPatients extends StatelessWidget {
  const AdminPatients({super.key});

  // final List<String> availableTypes = adminPatientsSortingTypes;
  // late List<AppUser> sortedPatients;
  // late String currentType;

  // void _onTypeDropdownSelect(String? newValue) {
  //   if (newValue! == adminPatientsSortingTypes[0]) {
  //     setState(() {
  //       currentType = newValue;
  //       sortedPatients = List.from([]);
  //       sortedPatients.sort((a, b) => a.getUserFullName().compareTo(b.getUserFullName()));
  //     });
  //   } else if (newValue == adminPatientsSortingTypes[1]) {
  //     setState(() {
  //       currentType = newValue;
  //       sortedPatients = List.from([]);
  //       sortedPatients.sort((a, b) => b.getUserFullName().compareTo(a.getUserFullName()));
  //     });
  //   } else if (newValue == adminPatientsSortingTypes[2]) {
  //     setState(() {
  //       currentType = newValue;
  //       sortedPatients = List.from([]);
  //       sortedPatients.sort((a, b) {
  //         final currentPlanA = a.getCurrentPlan();
  //         final currentPlanB = b.getCurrentPlan();
  //         final isEndDateNullA = currentPlanA == null;
  //         final isEndDateNullB = currentPlanB == null;

  //         // Check if endDate is null
  //         if (isEndDateNullA && !isEndDateNullB) {
  //           return -1; // a comes first if its endDate is null
  //         } else if (!isEndDateNullA && isEndDateNullB) {
  //           return 1; // b comes first if its endDate is null
  //         } else {
  //           // If both have non-null endDate, compare proximity to DateTime.now()
  //           Duration diffA = (currentPlanA!.endDate).difference(DateTime.now());
  //           Duration diffB = (currentPlanB!.endDate).difference(DateTime.now());
  //           return diffA.compareTo(diffB);
  //         }
  //       });
  //     });
  //   } else if (newValue == adminPatientsSortingTypes[3]) {
  //     setState(() {
  //       currentType = newValue;
  //       sortedPatients = List.from([]);
  //       sortedPatients.sort((a, b) {
  //         final currentPlanA = a.getCurrentPlan();
  //         final currentPlanB = b.getCurrentPlan();
  //         final isEndDateNullA = currentPlanA == null;
  //         final isEndDateNullB = currentPlanB == null;

  //         // Check if endDate is null
  //         if (!isEndDateNullA && isEndDateNullB) {
  //           return -1; // a comes first if its endDate is null
  //         } else if (isEndDateNullA && !isEndDateNullB) {
  //           return 1; // b comes first if its endDate is null
  //         } else {
  //           // If both have non-null endDate, compare proximity to DateTime.now()
  //           Duration diffA = (currentPlanA!.endDate).difference(DateTime.now());
  //           Duration diffB = (currentPlanB!.endDate).difference(DateTime.now());
  //           return diffB.compareTo(diffA);
  //         }
  //       });
  //     });
  //   } else if (newValue == adminPatientsSortingTypes[4]) {
  //     setState(() {
  //       currentType = newValue;
  //       sortedPatients = List.from([]);
  //       sortedPatients.sort((a, b) => a.registerDate.compareTo(b.registerDate));
  //     });
  //   } else if (newValue == adminPatientsSortingTypes[5]) {
  //     setState(() {
  //       currentType = newValue;
  //       sortedPatients = List.from([]);
  //       sortedPatients.sort((a, b) => b.registerDate.compareTo(a.registerDate));
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   sortedPatients = List.from([]);
  //   currentType = adminPatientsSortingTypes[0];
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Patients",
                            style: darkTextTheme().headlineLarge,
                          ),
                          Text(
                            "All Patient Users",
                            style: darkTextTheme().headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<PatientListBloc, PatientListState>(
                      builder: (context, state) {
                        if (state is PatientListDone) {
                          return IconButton(
                            onPressed: () {
                              BlocProvider.of<PatientListBloc>(context).add(const FetchPatientListEvent());
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 8),
              // [].isEmpty
              //     ? const SizedBox()
              //     : Row(
              //         children: [
              //           Text(
              //             'Sort by:',
              //             style: darkTextTheme().headlineSmall,
              //           ),
              //           const SizedBox(
              //             width: 12,
              //           ),
              //           Expanded(
              //             child: DropdownButtonFormField<String>(
              //               value: currentType,
              //               style: const TextStyle(
              //                 color: Colors.black,
              //                 fontFamily: 'Sailec Medium',
              //                 fontSize: 12,
              //                 overflow: TextOverflow.ellipsis,
              //               ),
              //               decoration: customDropdownDecoration.copyWith(
              //                 labelText: 'Type',
              //               ),
              //               onChanged: _onTypeDropdownSelect,
              //               items: availableTypes.map<DropdownMenuItem<String>>((String value) {
              //                 return DropdownMenuItem<String>(
              //                   value: value,
              //                   child: Text(value),
              //                 );
              //               }).toList(),
              //             ),
              //           ),
              //         ],
              //       ),
              const SizedBox(height: 16),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<PatientListBloc, PatientListState>(
      builder: (context, state) {
        if (state is PatientListNone || (state is PatientListDone && state.patientList.isEmpty)) {
          return const Text("The system has no patients", style: TextStyle(color: Colors.white));
        }
        if (state is PatientListLoading || state is PatientListDone) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.patientList.length,
                itemBuilder: (context, index) {
                  // Get the current patient
                  final patient = state.patientList[index];
                  // Display the patient's ID
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AdminPatientListCard(patient: patient),
                  );
                },
              ),
              if (state is PatientListLoading) ...[
                const CupertinoActivityIndicator(color: Colors.white),
              ],
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
