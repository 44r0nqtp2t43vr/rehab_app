import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityMonitor extends StatefulWidget {
  const ActivityMonitor({super.key});

  @override
  State<ActivityMonitor> createState() => _ActivityMonitorState();
}

class _ActivityMonitorState extends State<ActivityMonitor> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` to show selected day in month view
            });
          },
          selectedDayPredicate: (day) {
            // Use `selectedDayPredicate` to determine which day is currently selected.
            // If this returns `true`, then `day` will be marked as selected.
            return isSameDay(_selectedDay, day);
          },
        ),
      ],
    );
  }
}
