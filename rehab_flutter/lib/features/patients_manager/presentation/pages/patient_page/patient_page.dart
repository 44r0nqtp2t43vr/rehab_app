import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_state.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_details.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_plans_list.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/calendar.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/event_list.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/activity_chart_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/daily_progress_card.dart';
import 'package:rehab_flutter/features/tab_profile/presentation/widgets/profile_info_card.dart';
import 'package:table_calendar/table_calendar.dart';

class PatientPage extends StatefulWidget {
  final AppUser patient;

  const PatientPage({super.key, required this.patient});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  late Session currentSelectedSession;
  late Map<String, Color?> dateColorsMap;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Map<String, Color?> sessionsToDateColorsMap() {
    Map<String, Color?> dateColorsMap = {};

    for (var sesh in widget.patient.getAllSessionsFromAllPlans()) {
      final String dateString =
          "${sesh.date.year}${sesh.date.month}${sesh.date.day}";
      final List<bool> conditions = sesh.getSessionConditions();

      if (conditions[0] &&
          conditions[1] &&
          conditions[2] &&
          conditions[3] &&
          conditions[4]) {
        dateColorsMap[dateString] = heatmap5;
      } else if (conditions[0] &&
          conditions[1] &&
          conditions[2] &&
          conditions[3]) {
        dateColorsMap[dateString] = heatmap4;
      } else if (conditions[0] && conditions[1] && conditions[2]) {
        dateColorsMap[dateString] = heatmap3;
      } else if (conditions[0] && conditions[1]) {
        dateColorsMap[dateString] = heatmap2;
      } else if (conditions[0]) {
        dateColorsMap[dateString] = heatmap1;
      } else {
        dateColorsMap[dateString] = null;
      }
    }

    return dateColorsMap;
  }

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      currentSelectedSession =
          widget.patient.getAllSessionsFromAllPlans().firstWhere(
                (session) =>
                    session.date.year == _selectedDay.year &&
                    session.date.month == _selectedDay.month &&
                    session.date.day == _selectedDay.day,
                orElse: () => Session.empty(),
              );
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
  }

  void _onToggleFormat() {
    setState(() {
      _calendarFormat = _calendarFormat == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week;
    });
  }

  @override
  void initState() {
    super.initState();
    dateColorsMap = sessionsToDateColorsMap();
    currentSelectedSession =
        widget.patient.getAllSessionsFromAllPlans().firstWhere(
              (session) =>
                  session.date.year == _selectedDay.year &&
                  session.date.month == _selectedDay.month &&
                  session.date.day == _selectedDay.day,
              orElse: () => Session.empty(),
            );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TherapistBloc, TherapistState>(
      listener: (context, state) {
        if (state is TherapistDone) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is TherapistLoading) {
          return Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lotties/uploading.json',
                width: 400,
                height: 400,
              ),
              //CupertinoActivityIndicator(color: Colors.white),
            ),
          );
        }
        if (state is TherapistDone) {
          final currentSelectedSessionDateString = currentSelectedSession
                  .sessionId.isEmpty
              ? ""
              : "${currentSelectedSession.date.year}${currentSelectedSession.date.month}${currentSelectedSession.date.day}";

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          IconButton(
                            highlightColor: Colors.white.withOpacity(0.1),
                            icon: const Icon(
                              Icons.chevron_left,
                              size: 35,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Expanded(
                            child: ProfileInfoCard(user: widget.patient),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Patient Details",
                          style: darkTextTheme().displaySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      PatientDetails(patient: widget.patient),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Therapy Plans",
                          style: darkTextTheme().displaySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      PatientPlansList(patient: widget.patient),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Today's Activity",
                          style: darkTextTheme().displaySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: GlassContainer(
                              shadowStrength: 2,
                              shadowColor: Colors.black,
                              blur: 4,
                              color: Colors.white.withOpacity(0.25),
                              child: DailyProgressCard(
                                isTherapistView: true,
                                todaySession:
                                    widget.patient.getCurrentSession(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 5,
                            child: GlassContainer(
                              shadowStrength: 2,
                              shadowColor: Colors.black,
                              blur: 4,
                              color: Colors.white.withOpacity(0.25),
                              child: ActivityChartCard(user: widget.patient),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Therapy Calendar",
                          style: darkTextTheme().displaySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Calendar(
                        dateColorsMap: dateColorsMap,
                        calendarFormat: _calendarFormat,
                        focusedDay: _focusedDay,
                        selectedDay: _selectedDay,
                        selectedDayPredicate: _selectedDayPredicate,
                        onDaySelected: _onDaySelected,
                        onPageChanged: _onPageChanged,
                        onToggleFormat: _onToggleFormat,
                      ),
                      const SizedBox(height: 20),
                      EventList(
                        isTherapistView: true,
                        dayColor:
                            dateColorsMap[currentSelectedSessionDateString] ??
                                Colors.white,
                        selectedDay: _selectedDay,
                        currentSession: currentSelectedSession.sessionId.isEmpty
                            ? null
                            : currentSelectedSession,
                        conditions:
                            currentSelectedSession.getSessionConditions(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _onUnassignButtonPressed(
                                context,
                                state.currentTherapist!,
                                widget.patient.userId,
                              ),
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.white,
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xff128BED)),
                                elevation: MaterialStateProperty.all<double>(0),
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.white.withOpacity(0.2)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: const Text("Unassign"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void _onUnassignButtonPressed(
      BuildContext context, Therapist therapist, String patientId) {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Are you sure?",
                        style: TextStyle(
                          fontFamily: 'Sailec Bold',
                          fontSize: 22,
                          height: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "This will remove the patient from your list",
                        style: TextStyle(
                          fontFamily: 'Sailec Light',
                          fontSize: 16,
                          height: 1.2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Theme(
                      data: darkButtonTheme,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          BlocProvider.of<TherapistBloc>(context)
                              .add(AssignPatientEvent(AssignPatientData(
                            therapist: therapist,
                            patientId: patientId,
                            isAssign: false,
                          )));
                        },
                        child: const Text('Confirm'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: Theme(
                      data: darkButtonTheme,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
