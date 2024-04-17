import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/therapist_list_card.dart';

class AdminTherapists extends StatefulWidget {
  final Admin currentAdmin;

  const AdminTherapists({super.key, required this.currentAdmin});

  @override
  State<AdminTherapists> createState() => _AdminTherapistsState();
}

class _AdminTherapistsState extends State<AdminTherapists> {
  late List<Therapist> sortedTherapists;

  @override
  void initState() {
    sortedTherapists = List.from(widget.currentAdmin.therapists);
    super.initState();
  }

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
              // widget.currentAdmin.therapists.isEmpty
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
              //               decoration: customInputDecoration.copyWith(
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
              widget.currentAdmin.therapists.isEmpty
                  ? const Text("The system has no therapists", style: TextStyle(color: Colors.white))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedTherapists.length,
                      itemBuilder: (context, index) {
                        final therapist = sortedTherapists[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TherapistListCard(therapist: therapist),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
