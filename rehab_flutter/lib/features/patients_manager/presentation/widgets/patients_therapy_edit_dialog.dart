import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/standard_therapy_types.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_session_data.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/standard_therapy_type.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_event.dart';

final intensityValues = [1, 2, 3, 4, 5];

class PatientsTherapyEditDialog extends StatefulWidget {
  final PatientPlan patientPlan;
  final Session session;
  final String title;

  const PatientsTherapyEditDialog({super.key, required this.patientPlan, required this.session, required this.title});

  @override
  State<PatientsTherapyEditDialog> createState() => _PatientsTherapyEditDialogState();
}

class _PatientsTherapyEditDialogState extends State<PatientsTherapyEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late StandardTherapyType? standardOneType;
  late StandardTherapyType? standardTwoType;
  late int? standardOneIntensity;
  late int? standardTwoIntensity;
  late int? passiveIntensity;

  void _editSession(BuildContext context) {
    EditSessionData editSessionData = EditSessionData(
      userId: widget.patientPlan.patient.userId,
      planId: widget.patientPlan.plan.planId,
      sessionId: widget.session.sessionId,
      standardOneType: standardOneType!.value,
      standardOneIntensity: standardOneIntensity!.toString(),
      passiveIntensity: passiveIntensity!.toString(),
      standardTwoType: standardTwoType!.value,
      standardTwoIntensity: standardTwoIntensity!.toString(),
    );

    BlocProvider.of<ViewedTherapistPatientPlanSessionsListBloc>(context).add(EditViewedTherapistPatientPlanSessionsListEvent(editSessionData));
  }

  @override
  void initState() {
    standardOneType = standardTherapyTypes.firstWhere((type) => type.value == widget.session.standardOneType, orElse: () => StandardTherapyType.empty());
    standardTwoType = standardTherapyTypes.firstWhere((type) => type.value == widget.session.standardTwoType, orElse: () => StandardTherapyType.empty());
    standardOneType = standardOneType == StandardTherapyType.empty() ? null : standardOneType;
    standardTwoType = standardTwoType == StandardTherapyType.empty() ? null : standardTwoType;
    standardOneIntensity = widget.session.standardOneIntensity.isEmpty ? null : int.parse(widget.session.standardOneIntensity);
    standardTwoIntensity = widget.session.standardTwoIntensity.isEmpty ? null : int.parse(widget.session.standardTwoIntensity);
    passiveIntensity = widget.session.passiveIntensity.isEmpty ? null : int.parse(widget.session.passiveIntensity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      blur: 10,
      color: Colors.white.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'Sailec Bold',
                      fontSize: 22,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Date: ${DateFormat('MMMM dd, yyyy').format(widget.session.date)}",
                    style: darkTextTheme().headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<StandardTherapyType?>(
                    value: standardOneType,
                    isExpanded: true,
                    decoration: customInputDecoration.copyWith(
                      labelText: 'Standard One Intensity',
                    ),
                    onChanged: (StandardTherapyType? newValue) {
                      setState(() {
                        standardOneType = newValue!;
                      });
                    },
                    items: [
                      const DropdownMenuItem<StandardTherapyType?>(
                        value: null,
                        child: Text('Select'),
                      ),
                      ...standardTherapyTypes.map<DropdownMenuItem<StandardTherapyType>>((StandardTherapyType value) {
                        return DropdownMenuItem<StandardTherapyType>(
                          value: value,
                          child: Text(
                            value.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    value: standardOneIntensity,
                    decoration: customInputDecoration.copyWith(
                      labelText: 'Standard One Intensity',
                    ),
                    onChanged: (int? newValue) {
                      setState(() {
                        standardOneIntensity = newValue!;
                      });
                    },
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Select'),
                      ),
                      ...intensityValues.map<DropdownMenuItem<int?>>((int? value) {
                        return DropdownMenuItem<int?>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    value: passiveIntensity,
                    decoration: customInputDecoration.copyWith(
                      labelText: 'Passive Intensity',
                    ),
                    onChanged: (int? newValue) {
                      setState(() {
                        passiveIntensity = newValue!;
                      });
                    },
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Select'),
                      ),
                      ...intensityValues.map<DropdownMenuItem<int?>>((int? value) {
                        return DropdownMenuItem<int?>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<StandardTherapyType?>(
                    value: standardTwoType,
                    isExpanded: true,
                    decoration: customInputDecoration.copyWith(
                      labelText: 'Standard One Intensity',
                    ),
                    onChanged: (StandardTherapyType? newValue) {
                      setState(() {
                        standardTwoType = newValue!;
                      });
                    },
                    items: [
                      const DropdownMenuItem<StandardTherapyType?>(
                        value: null,
                        child: Text('Select'),
                      ),
                      ...standardTherapyTypes.map<DropdownMenuItem<StandardTherapyType>>((StandardTherapyType value) {
                        return DropdownMenuItem<StandardTherapyType>(
                          value: value,
                          child: Text(
                            value.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int?>(
                    value: standardTwoIntensity,
                    decoration: customInputDecoration.copyWith(
                      labelText: 'Standard Two Intensity',
                    ),
                    onChanged: (int? newValue) {
                      setState(() {
                        standardTwoIntensity = newValue!;
                      });
                    },
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Select'),
                      ),
                      ...intensityValues.map<DropdownMenuItem<int?>>((int? value) {
                        return DropdownMenuItem<int?>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a value';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Theme(
                    data: darkButtonTheme,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Theme(
                    data: darkButtonTheme,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).pop();
                          _editSession(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
