import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/session.dart';
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
  late Session currentSelectedSession;
  late Map<String, Color?> dateColorsMap;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  Map<String, Color?> sessionsToDateColorsMap() {
    Map<String, Color?> dateColorsMap = {};

    for (var sesh in widget.sessions) {
      final String dateString = "${sesh.date.year}${sesh.date.month}${sesh.date.day}";
      final List<bool> conditions = sesh.getSessionConditions();

      if (conditions[0] && conditions[1] && conditions[2] && conditions[3] && conditions[4]) {
        dateColorsMap[dateString] = heatmap5;
      } else if (conditions[0] && conditions[1] && conditions[2] && conditions[3]) {
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
        (session) => session.date.year == _selectedDay.year && session.date.month == _selectedDay.month && session.date.day == _selectedDay.day,
        orElse: () => Session.empty(),
      );
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
    currentSelectedSession = widget.sessions.firstWhere(
      (session) => session.date.year == _selectedDay.year && session.date.month == _selectedDay.month && session.date.day == _selectedDay.day,
      orElse: () => Session.empty(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSelectedSessionDateString = currentSelectedSession.sessionId.isEmpty ? "" : "${currentSelectedSession.date.year}${currentSelectedSession.date.month}${currentSelectedSession.date.day}";

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
          isTherapistView: true,
          dayColor: dateColorsMap[currentSelectedSessionDateString] ?? Colors.white,
          selectedDay: _selectedDay,
          currentSession: currentSelectedSession.sessionId.isEmpty ? null : currentSelectedSession,
          conditions: currentSelectedSession.getSessionConditions(),
        ),
      ],
    );
  }
}
