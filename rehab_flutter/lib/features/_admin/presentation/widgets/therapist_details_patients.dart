import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_state.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_therapist/viewed_therapist_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_therapist/viewed_therapist_event.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_list_card.dart';

class TherapistDetailsPatients extends StatefulWidget {
  final Therapist therapist;

  const TherapistDetailsPatients({super.key, required this.therapist});

  @override
  State<TherapistDetailsPatients> createState() => _TherapistDetailsPatientsState();
}

class _TherapistDetailsPatientsState extends State<TherapistDetailsPatients> {
  final _formKey = GlobalKey<FormState>();
  AppUser? _selectedPatientToAdd;

  void _onPatientDropdownSelect(AppUser? newValue) {
    setState(() {
      _selectedPatientToAdd = newValue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final patients = widget.therapist.patients;

    return Column(
      children: [
        patients.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("This therapist has no assigned patients", style: darkTextTheme().headlineSmall),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  // Get the current patient
                  final patient = patients[index];
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
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _onAddPatientButtonPressed(context),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff128BED)),
                  elevation: MaterialStateProperty.all<double>(0),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.2)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: const Text("Add Patient"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _onAddPatientButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          content: GlassContainer(
            blur: 10,
            color: Colors.white.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose patient to add:",
                      style: darkTextTheme().headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<PatientListBloc, PatientListState>(
                      builder: (context, state) {
                        if (state is PatientListLoading) {
                          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
                        }
                        if (state is PatientListDone) {
                          final assignedPatientsIds = widget.therapist.patients.map((patient) => patient.userId).toList();
                          final availablePatients = state.patientList.where((patient) => !assignedPatientsIds.contains(patient.userId)).toList();

                          return DropdownButtonFormField<AppUser>(
                            value: _selectedPatientToAdd,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Sailec Medium',
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                            decoration: customDropdownDecoration.copyWith(
                              labelText: 'Patient',
                            ),
                            onChanged: _onPatientDropdownSelect,
                            items: availablePatients.map<DropdownMenuItem<AppUser>>((AppUser patient) {
                              return DropdownMenuItem<AppUser>(
                                value: patient,
                                child: Text(patient.getUserFullName()),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a patient';
                              }
                              return null;
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Theme(
                            data: darkButtonTheme,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _onAddButtonPressed(context);
                                }
                              },
                              child: const Text('Add Patient'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Theme(
                            data: darkButtonTheme,
                            child: ElevatedButton(
                              onPressed: () => _onBackButtonPressed(context),
                              child: const Text('Cancel'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onAddButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    BlocProvider.of<ViewedTherapistBloc>(context).add(AssignViewedTherapistEvent(AssignPatientData(
      therapist: widget.therapist,
      patientId: _selectedPatientToAdd!.userId,
    )));
  }

  void _onBackButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
