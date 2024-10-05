import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/calendar.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/event_list.dart';
import 'package:table_calendar/table_calendar.dart';

class TherapyCalendar extends StatefulWidget {
  final List<Session> sessions;

  const TherapyCalendar({super.key, required this.sessions});

  @override
  State<TherapyCalendar> createState() => _TherapyCalendarState();
}

class _TherapyCalendarState extends State<TherapyCalendar> {
  late Map<String, Color?> dateColorsMap;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Map<String, Color?> sessionsToDateColorsMap() {
    Map<String, Color?> dateColorsMap = {};

    for (var sesh in widget.sessions) {
      for (int i = 0; i < sesh.dailyActivities.length; i++) {
        final String dateString = sesh.dailyActivities[i].split("_")[0];
        final List<bool> conditions = sesh.getDayActivitiesConditions(dateString);

        if (conditions[2]) {
          dateColorsMap[dateString] = heatmap5;
        } else if (conditions[1]) {
          dateColorsMap[dateString] = heatmap3;
        } else if (conditions[0]) {
          dateColorsMap[dateString] = heatmap1;
        } else {
          dateColorsMap[dateString] = null;
        }
      }
    }

    return dateColorsMap;
  }

  Session? getCurrentSelectedSession() {
    final session = widget.sessions.firstWhere(
      (session) => session.endDate.isAfter(_selectedDay),
      orElse: () => Session.empty(),
    );
    return session.sessionId.isEmpty ? null : session;
  }

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
  }

  void _onToggleFormat() {
    setState(() {
      _calendarFormat = _calendarFormat == CalendarFormat.week ? CalendarFormat.month : CalendarFormat.week;
    });
  }

  @override
  void initState() {
    super.initState();
    dateColorsMap = sessionsToDateColorsMap();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          dayColor: dateColorsMap[formatDateMMDDYYYY(_selectedDay)] ?? Colors.white,
          selectedDay: _selectedDay,
          currentSession: getCurrentSelectedSession(),
        ),
      ],
    );
  }
}
