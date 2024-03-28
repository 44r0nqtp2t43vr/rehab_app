import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/calendar.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/event_list.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityMonitor extends StatefulWidget {
  final List<Session> sessions;

  const ActivityMonitor({super.key, required this.sessions});

  @override
  State<ActivityMonitor> createState() => _ActivityMonitorState();
}

class _ActivityMonitorState extends State<ActivityMonitor> {
  late Session currentSelectedSession;
  late Map<String, Color?> dateColorsMap;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Map<String, Color?> sessionsToDateColorsMap() {
    Map<String, Color?> dateColorsMap = {};

    for (var sesh in widget.sessions) {
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
      currentSelectedSession = widget.sessions.firstWhere(
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
    currentSelectedSession = widget.sessions.firstWhere(
      (session) =>
          session.date.year == _selectedDay.year &&
          session.date.month == _selectedDay.month &&
          session.date.day == _selectedDay.day,
      orElse: () => Session.empty(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, UserState state) {
        if (state is UserLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is UserDone) {
          final currentSelectedSessionDateString =
              "${currentSelectedSession.date.year}${currentSelectedSession.date.month}${currentSelectedSession.date.day}";
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
                          "Activity Monitor",
                          style: darkTextTheme().headlineLarge,
                        ),
                        Text(
                          "Monthly Progress",
                          style: darkTextTheme().headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
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
                  const SizedBox(height: 32),
                  EventList(
                    dayColor: dateColorsMap[currentSelectedSessionDateString] ??
                        Colors.white,
                    selectedDay: _selectedDay,
                    currentSession: currentSelectedSession.sessionId.isEmpty
                        ? null
                        : currentSelectedSession,
                    conditions: currentSelectedSession.getSessionConditions(),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
