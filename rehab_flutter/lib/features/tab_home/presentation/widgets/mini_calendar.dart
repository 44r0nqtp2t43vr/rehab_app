import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:table_calendar/table_calendar.dart';

class MiniCalendar extends StatefulWidget {
  final DateTime focusedDay;
  final List<Plan> plans;
  final Function(DateTime) onPageChanged;

  const MiniCalendar({
    super.key,
    required this.plans,
    required this.focusedDay,
    required this.onPageChanged,
  });

  @override
  State<MiniCalendar> createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<MiniCalendar> {
  late Map<String, Color?> dateColorsMap;

  Map<String, Color?> getDateColorsMapFromPlans(List<Plan> plans) {
    Map<String, Color?> dateColorsMap = {};
    List<Session> sessions = plans.expand((plan) => plan.sessions).toList();

    for (var sesh in sessions) {
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

  @override
  void initState() {
    dateColorsMap = getDateColorsMapFromPlans(widget.plans);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      shadowStrength: 2,
      shadowColor: Colors.black,
      blur: 4,
      color: Colors.white.withOpacity(0.25),
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2025, 12, 31),
        focusedDay: widget.focusedDay,
        calendarFormat: CalendarFormat.month,
        headerVisible: false,
        onPageChanged: widget.onPageChanged,
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
            final dateString = formatDateMMDDYYYY(date);
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
                          color: color == heatmap4 || color == heatmap5 ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
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
                          color: color == heatmap4 || color == heatmap5 ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },

          selectedBuilder: (context, date, _) {
            //final dateString = "${date.year}${date.month}${date.day}";
            return Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xff275492),
                border: Border.all(
                  strokeAlign: BorderSide.strokeAlignOutside,
                  width: 2,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
          todayBuilder: (context, date, _) {
            final dateString = formatDateMMDDYYYY(date);
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
                          color: color == heatmap4 || color == heatmap5 ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xff275492),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
