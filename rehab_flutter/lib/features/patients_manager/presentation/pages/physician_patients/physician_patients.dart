import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/patient_sorting_type.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_list_card.dart';

class PhysicianPatients extends StatefulWidget {
  final List<AppUser> patients;

  const PhysicianPatients({super.key, required this.patients});

  @override
  State<PhysicianPatients> createState() => _PhysicianPatientsState();
}

class _PhysicianPatientsState extends State<PhysicianPatients> {
  final List<String> availableTypes = availableSortingTypes;
  late List<AppUser> sortedPatients;
  late String currentType;

  void _onTypeDropdownSelect(String? newValue) {
    if (newValue! == availableSortingTypes[0]) {
      setState(() {
        currentType = newValue;
        sortedPatients = List.from(widget.patients);
      });
    } else if (newValue == availableSortingTypes[1]) {
      setState(() {
        currentType = newValue;
        sortedPatients = List.from(widget.patients.reversed);
      });
    } else if (newValue == availableSortingTypes[2]) {
      setState(() {
        currentType = newValue;
        sortedPatients
            .sort((a, b) => a.getUserFullName().compareTo(b.getUserFullName()));
      });
    } else if (newValue == availableSortingTypes[3]) {
      setState(() {
        currentType = newValue;
        sortedPatients
            .sort((a, b) => b.getUserFullName().compareTo(a.getUserFullName()));
      });
    } else if (newValue == availableSortingTypes[4]) {
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
    } else if (newValue == availableSortingTypes[5]) {
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
    sortedPatients = List.from(widget.patients);
    currentType = availableSortingTypes[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                      "Your Assigned Patients",
                      style: darkTextTheme().headlineSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              widget.patients.isEmpty
                  ? const SizedBox()
                  : Row(
                      children: [
                        const Text(
                          'Sort by:',
                          style: TextStyle(
                            fontFamily: 'Sailec Medium',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: currentType,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sailec Medium',
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                            decoration: customDropdownDecoration.copyWith(
                              labelText: 'Type',
                            ),
                            onChanged: _onTypeDropdownSelect,
                            items: availableTypes
                                .map<DropdownMenuItem<String>>((String value) {
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
              widget.patients.isEmpty
                  ? const Text("You have no assigned patients",
                      style: TextStyle(color: Colors.white))
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
                            onPressedRoute: "/PatientPage",
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
