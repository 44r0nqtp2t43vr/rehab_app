import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_state.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
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
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminDone && state.currentAdmin!.therapists == null) {
          return BlocProvider(
            create: (_) => sl<TherapistListBloc>()..add(const FetchTherapistListEvent()),
            child: _buildWidget(context: context, currentAdmin: state.currentAdmin!),
          );
        }
        if (state is AdminDone && state.currentAdmin!.therapists != null) {
          return _buildWidget(context: context, currentAdmin: state.currentAdmin!);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildWidget({required BuildContext context, required Admin currentAdmin}) {
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
                    IconButton(
                      onPressed: () {
                        currentAdmin.therapists = null;
                        BlocProvider.of<AdminBloc>(context).add(UpdateAdminEvent(currentAdmin));
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
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
              currentAdmin.therapists == null ? _buildBlocBody(currentAdmin: currentAdmin) : _buildTherapistsList(therapists: currentAdmin.therapists!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlocBody({required Admin currentAdmin}) {
    return BlocConsumer<TherapistListBloc, TherapistListState>(
      listener: (context, state) {
        if (state is TherapistListDone) {
          currentAdmin.therapists = state.therapistList;
          BlocProvider.of<AdminBloc>(context).add(GetAdminEvent(currentAdmin));
        }
      },
      builder: (context, state) {
        if (state is TherapistListNone || (state is TherapistListDone && state.therapistList.isEmpty)) {
          return const Text("The system has no therapists", style: TextStyle(color: Colors.white));
        }
        if (state is TherapistListLoading || state is TherapistListDone) {
          return Column(
            children: [
              _buildTherapistsList(therapists: state.therapistList),
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

  Widget _buildTherapistsList({required List<Therapist> therapists}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: therapists.length,
      itemBuilder: (context, index) {
        // Get the current patient
        final therapist = therapists[index];
        // Display the patient's ID
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TherapistListCard(
            therapist: therapist,
          ),
        );
      },
    );
  }
}
