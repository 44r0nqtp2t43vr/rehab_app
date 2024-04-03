import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/pages/activity_monitor/activity_monitor.dart';
import 'package:table_calendar/table_calendar.dart';

class MiniCalendar extends StatelessWidget {
  final AppUser? user;
  final DateTime focusedDay;
  final Map<String, Color?> dateColorsMap;
  final Function(DateTime) onPageChanged;

  const MiniCalendar(
      {super.key,
      required this.user,
      required this.dateColorsMap,
      required this.focusedDay,
      required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      shadowStrength: 2,
      shadowColor: Colors.black,
      blur: 4,
      color: Colors.white.withOpacity(0.25),
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2024, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: CalendarFormat.month,
        headerVisible: false,
        onPageChanged: onPageChanged,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          tablePadding: const EdgeInsets.all(16),
          todayDecoration: BoxDecoration(
            color: const Color(0xFF9FA8DA),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
          ),
          selectedDecoration: BoxDecoration(
            color: const Color(0xFF5C6BC0),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
          ),
          weekendTextStyle: const TextStyle(color: Colors.white),
          defaultTextStyle: const TextStyle(color: Colors.white),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white),
          weekendStyle: TextStyle(color: Colors.white),
        ),
        calendarBuilders: CalendarBuilders(
          // Customize the appearance of individual calendar cells
          defaultBuilder: (context, date, _) {
            final dateString = "${date.year}${date.month}${date.day}";
            final color = dateColorsMap[dateString];

            if (color != null) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: color == heatmap4 || color == heatmap5
                              ? Colors.white.withOpacity(0.3)
                              : Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: color == heatmap4 || color == heatmap5
                              ? Colors.white.withOpacity(0.3)
                              : Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
          todayBuilder: (context, date, _) {
            final dateString = "${date.year}${date.month}${date.day}";
            final color = dateColorsMap[dateString];

            if (color != null) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: color == heatmap4 || color == heatmap5
                              ? Colors.white.withOpacity(0.3)
                              : Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}
