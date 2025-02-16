import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/edit_session_data.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_event.dart';

final intensityValues = ["1", "2", "3", "4", "5"];
final standardTherapyValues = ["pod", "ptd", "ttd", "bms", "ims"];

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
  late List<String> dailyActivities;

  void setDailyActivities(int index, String newString) {
    setState(() {
      dailyActivities[index] = newString;
    });
  }

  void _editSession(BuildContext context) {
    EditSessionData editSessionData = EditSessionData(
      userId: widget.patientPlan.patient.userId,
      planId: widget.patientPlan.plan.planId,
      sessionId: widget.session.sessionId,
      newDailyActivities: dailyActivities,
    );

    BlocProvider.of<ViewedTherapistPatientPlanSessionsListBloc>(context).add(EditViewedTherapistPatientPlanSessionsListEvent(editSessionData));
  }

  @override
  void initState() {
    dailyActivities = List.from(widget.session.dailyActivities);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GlassContainer(
        blur: 10,
        color: Colors.white.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dailyActivities.length,
                  itemBuilder: (context, i) {
                    final dailyActivity = dailyActivities[i];
                    final dailyActivityDetails = dailyActivity.split("_");
                    final dailyActivityDateString = formatDateMMDD(parseMMDDYYYY(dailyActivity.split("_")[0]));

                    final standardOneType = dailyActivityDetails[1].substring(0, 3);
                    final standardTwoType = dailyActivityDetails[2].substring(0, 3);

                    final standardOneIntensity = dailyActivityDetails[1][3];
                    final standardTwoIntensity = dailyActivityDetails[2][3];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              dailyActivityDateString,
                              style: darkTextTheme().headlineSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: DropdownButtonFormField<String>(
                              value: standardOneType,
                              dropdownColor: Color(0XFF275492),
                              borderRadius: BorderRadius.circular(12),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              onChanged: (String? newValue) {
                                final newStandardOneDetails = "${newValue}${standardOneIntensity}";
                                final newDailyActivityDetails = List.from(dailyActivityDetails);
                                newDailyActivityDetails[1] = newStandardOneDetails;

                                final newDailyActivityString = newDailyActivityDetails.join("_");
                                setDailyActivities(i, newDailyActivityString);
                              },
                              items: [
                                ...standardTherapyValues.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return "";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: DropdownButtonFormField<String>(
                              value: standardOneIntensity,
                              dropdownColor: Color(0XFF275492),
                              borderRadius: BorderRadius.circular(12),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              onChanged: (String? newValue) {
                                final newStandardOneDetails = "${standardOneType}${newValue}";
                                final newDailyActivityDetails = List.from(dailyActivityDetails);
                                newDailyActivityDetails[1] = newStandardOneDetails;

                                final newDailyActivityString = newDailyActivityDetails.join("_");
                                setDailyActivities(i, newDailyActivityString);
                              },
                              items: [
                                ...intensityValues.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return "";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: DropdownButtonFormField<String>(
                              value: standardTwoType,
                              dropdownColor: Color(0XFF275492),
                              borderRadius: BorderRadius.circular(12),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              onChanged: (String? newValue) {
                                final newStandardTwoDetails = "${newValue}${standardTwoIntensity}";
                                final newDailyActivityDetails = List.from(dailyActivityDetails);
                                newDailyActivityDetails[2] = newStandardTwoDetails;

                                final newDailyActivityString = newDailyActivityDetails.join("_");
                                setDailyActivities(i, newDailyActivityString);
                              },
                              items: [
                                ...standardTherapyValues.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return "";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: DropdownButtonFormField<String>(
                              value: standardTwoIntensity,
                              dropdownColor: Color(0XFF275492),
                              borderRadius: BorderRadius.circular(12),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              onChanged: (String? newValue) {
                                final newStandardTwoDetails = "${standardTwoType}${newValue}";
                                final newDailyActivityDetails = List.from(dailyActivityDetails);
                                newDailyActivityDetails[2] = newStandardTwoDetails;

                                final newDailyActivityString = newDailyActivityDetails.join("_");
                                setDailyActivities(i, newDailyActivityString);
                              },
                              items: [
                                ...intensityValues.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                              validator: (value) {
                                if (value == null) {
                                  return "";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
      ),
    );
  }
}
