import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/physician_list_card.dart';

class AdminPhysicians extends StatefulWidget {
  final Admin currentAdmin;

  const AdminPhysicians({super.key, required this.currentAdmin});

  @override
  State<AdminPhysicians> createState() => _AdminPhysiciansState();
}

class _AdminPhysiciansState extends State<AdminPhysicians> {
  late List<Physician> sortedPhysicians;

  @override
  void initState() {
    sortedPhysicians = List.from(widget.currentAdmin.physicians);
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
                      "Physicians",
                      style: darkTextTheme().headlineLarge,
                    ),
                    Text(
                      "All Physician Users",
                      style: darkTextTheme().headlineSmall,
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 8),
              // widget.currentAdmin.physicians.isEmpty
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
              widget.currentAdmin.physicians.isEmpty
                  ? const Text("The system has no physicians", style: TextStyle(color: Colors.white))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedPhysicians.length,
                      itemBuilder: (context, index) {
                        final physician = sortedPhysicians[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: PhysicianListCard(physician: physician),
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
