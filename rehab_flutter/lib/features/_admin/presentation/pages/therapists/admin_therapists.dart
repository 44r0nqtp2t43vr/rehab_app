import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_state.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/therapist_list_card.dart';
import 'package:rehab_flutter/injection_container.dart';

class AdminTherapists extends StatelessWidget {
  final Admin currentAdmin;

  const AdminTherapists({super.key, required this.currentAdmin});

//   @override
//   State<AdminTherapists> createState() => _AdminTherapistsState();
// }

// class _AdminTherapistsState extends State<AdminTherapists> {
//   final List<String> availableTypes = adminTherapistsSortingTypes;
//   late List<Therapist> sortedTherapists;
//   late String currentType;

//   void _onTypeDropdownSelect(String? newValue) {
//     if (newValue! == adminPatientsSortingTypes[0]) {
//       setState(() {
//         currentType = newValue;
//         sortedTherapists = List.from([]);
//         sortedTherapists.sort((a, b) => a.getUserFullName().compareTo(b.getUserFullName()));
//       });
//     } else if (newValue == adminPatientsSortingTypes[1]) {
//       setState(() {
//         currentType = newValue;
//         sortedTherapists = List.from([]);
//         sortedTherapists.sort((a, b) => b.getUserFullName().compareTo(a.getUserFullName()));
//       });
//     } else if (newValue == adminPatientsSortingTypes[2]) {
//       setState(() {
//         currentType = newValue;
//         sortedTherapists = List.from([]);
//         sortedTherapists.sort((a, b) => b.patients.length.compareTo(a.patients.length));
//       });
//     } else if (newValue == adminPatientsSortingTypes[3]) {
//       setState(() {
//         currentType = newValue;
//         sortedTherapists = List.from([]);
//         sortedTherapists.sort((a, b) => a.patients.length.compareTo(b.patients.length));
//       });
//     } else if (newValue == adminPatientsSortingTypes[4]) {
//       setState(() {
//         currentType = newValue;
//         sortedTherapists = List.from([]);
//         sortedTherapists.sort((a, b) => a.registerDate.compareTo(b.registerDate));
//       });
//     } else if (newValue == adminPatientsSortingTypes[5]) {
//       setState(() {
//         currentType = newValue;
//         sortedTherapists = List.from([]);
//         sortedTherapists.sort((a, b) => b.registerDate.compareTo(a.registerDate));
//       });
//     }
//   }

//   @override
//   void initState() {
//     sortedTherapists = List.from([]);
//     currentType = adminTherapistsSortingTypes[0];
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TherapistListBloc>()..add(const FetchTherapistListEvent()),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
                        "Therapists",
                        style: darkTextTheme().headlineLarge,
                      ),
                      Text(
                        "All Therapist Users",
                        style: darkTextTheme().headlineSmall,
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
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<TherapistListBloc, TherapistListState>(
      builder: (context, state) {
        if (state is TherapistListNone || (state is TherapistListDone && state.therapistList.isEmpty)) {
          return const Text("The system has no patients", style: TextStyle(color: Colors.white));
        }
        if (state is TherapistListLoading || state is TherapistListDone) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.therapistList.length,
                itemBuilder: (context, index) {
                  // Get the current patient
                  final therapist = state.therapistList[index];
                  // Display the patient's ID
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TherapistListCard(
                      therapist: therapist,
                    ),
                  );
                },
              ),
              if (state is TherapistListLoading) ...[
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
