import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final Map<DateTime, Color?> dateColorsMap;
  final CalendarFormat calendarFormat;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final bool Function(DateTime)? selectedDayPredicate;
  final Function(DateTime, DateTime)? onDaySelected;
  final void Function(DateTime)? onPageChanged;
  final void Function() onToggleFormat;

  const Calendar({
    super.key,
    required this.dateColorsMap,
    required this.calendarFormat,
    required this.focusedDay,
    required this.selectedDay,
    required this.selectedDayPredicate,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onToggleFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
        border: Border.all(color: Colors.black), // Adjust border color as needed
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: focusedDay,
            calendarFormat: calendarFormat,
            selectedDayPredicate: selectedDayPredicate,
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Color(0xFF9FA8DA), shape: BoxShape.rectangle),
              selectedDecoration: BoxDecoration(color: Color(0xFF5C6BC0), shape: BoxShape.rectangle),
            ),
            calendarBuilders: CalendarBuilders(
              // Customize the appearance of individual calendar cells
              defaultBuilder: (context, date, _) {
                final color = dateColorsMap[date];
                if (color != null) {
                  // If the date has custom colors defined, use them
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: color,
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  // If there are no custom colors defined, use the default style
                  return null;
                }
              },
              // Customize the appearance of the focused day
              todayBuilder: (context, date, _) {
                final color = dateColorsMap[date];
                if (color != null) {
                  // If the date has custom colors defined, use them
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: color,
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  // If there are no custom colors defined, use the default style
                  return null;
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(calendarFormat == CalendarFormat.week ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
            onPressed: () => onToggleFormat(),
          ),
        ],
      ),
    );
  }
}
