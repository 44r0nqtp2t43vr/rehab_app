import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/_admin/domain/enums/admin_patients_sorting_types.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_list_card.dart';

class AdminPatients extends StatefulWidget {
  final Admin currentAdmin;

  const AdminPatients({super.key, required this.currentAdmin});

  @override
  State<AdminPatients> createState() => _AdminPatientsState();
}

class _AdminPatientsState extends State<AdminPatients> {
  final List<String> availableTypes = adminPatientsSortingTypes;
  late List<AppUser> sortedPatients;
  late String currentType;

  void _onTypeDropdownSelect(String? newValue) {
    if (newValue! == adminPatientsSortingTypes[0]) {
      setState(() {
        currentType = newValue;
        sortedPatients.sort((a, b) => a.getUserFullName().compareTo(b.getUserFullName()));
      });
    } else if (newValue == adminPatientsSortingTypes[1]) {
      setState(() {
        currentType = newValue;
        sortedPatients.sort((a, b) => b.getUserFullName().compareTo(a.getUserFullName()));
      });
    } else if (newValue == adminPatientsSortingTypes[2]) {
      setState(() {
        currentType = newValue;
        sortedPatients.sort((a, b) {
          final currentPlanA = a.getCurrentPlan();
          final currentPlanB = b.getCurrentPlan();
          final isEndDateNullA = currentPlanA == null;
          final isEndDateNullB = currentPlanB == null;

          // Check if endDate is null
          if (isEndDateNullA && !isEndDateNullB) {
            return -1; // a comes first if its endDate is null
          } else if (!isEndDateNullA && isEndDateNullB) {
            return 1; // b comes first if its endDate is null
          } else {
            // If both have non-null endDate, compare proximity to DateTime.now()
            Duration diffA = (currentPlanA!.endDate).difference(DateTime.now());
            Duration diffB = (currentPlanB!.endDate).difference(DateTime.now());
            return diffA.compareTo(diffB);
          }
        });
      });
    } else if (newValue == adminPatientsSortingTypes[3]) {
      setState(() {
        currentType = newValue;
        sortedPatients.sort((b, a) {
          final currentPlanA = a.getCurrentPlan();
          final currentPlanB = b.getCurrentPlan();
          final isEndDateNullA = currentPlanA == null;
          final isEndDateNullB = currentPlanB == null;

          // Check if endDate is null
          if (isEndDateNullA && !isEndDateNullB) {
            return -1; // a comes first if its endDate is null
          } else if (!isEndDateNullA && isEndDateNullB) {
            return 1; // b comes first if its endDate is null
          } else {
            // If both have non-null endDate, compare proximity to DateTime.now()
            Duration diffA = (currentPlanA!.endDate).difference(DateTime.now());
            Duration diffB = (currentPlanB!.endDate).difference(DateTime.now());
            return diffA.compareTo(diffB);
          }
        });
      });
    }
  }

  @override
  void initState() {
    sortedPatients = List.from(widget.currentAdmin.patients);
    currentType = adminPatientsSortingTypes[0];
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
              const SizedBox(height: 8),
              widget.currentAdmin.patients.isEmpty
                  ? const SizedBox()
                  : Row(
                      children: [
                        Text(
                          'Sort by:',
                          style: darkTextTheme().headlineSmall,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: currentType,
                            decoration: customInputDecoration.copyWith(
                              labelText: 'Type',
                            ),
                            onChanged: _onTypeDropdownSelect,
                            items: availableTypes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 16),
              widget.currentAdmin.patients.isEmpty
                  ? const Text("The system has no patients", style: TextStyle(color: Colors.white))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedPatients.length,
                      itemBuilder: (context, index) {
                        // Get the current patient
                        final patient = sortedPatients[index];
                        // Display the patient's ID
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: PatientListCard(
                            patient: patient,
                            onPressedRoute: "/AdminPatientPage",
                          ),
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
