import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:table_calendar/table_calendar.dart';

class MiniCalendar extends StatelessWidget {
  final AppUser? user;
  final DateTime focusedDay;
  final Map<String, Color?> dateColorsMap;
  final Function(DateTime) onPageChanged;

  const MiniCalendar({super.key, required this.user, required this.dateColorsMap, required this.focusedDay, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2024, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: CalendarFormat.month,
        headerVisible: false,
        onPageChanged: onPageChanged,
        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(color: Color(0xFF9FA8DA), shape: BoxShape.rectangle),
          selectedDecoration: BoxDecoration(color: Color(0xFF5C6BC0), shape: BoxShape.rectangle),
        ),
        calendarBuilders: CalendarBuilders(
          // Customize the appearance of individual calendar cells
          defaultBuilder: (context, date, _) {
            final dateString = "${date.year}${date.month}${date.day}";
            final color = dateColorsMap[dateString];

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
    );
  }
}
