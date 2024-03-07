import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityMonitor extends StatefulWidget {
  const ActivityMonitor({super.key});

  @override
  State<ActivityMonitor> createState() => _ActivityMonitorState();
}

class _ActivityMonitorState extends State<ActivityMonitor> {
  late Map<DateTime, Color?> dateColorsMap;

  // Sample data
  final List<Session> sessions = [
    Session(
      sessionId: "session_1",
      planId: "plan_1",
      date: DateTime.utc(2024, 3, 7),
      activityOneType: "textures",
      activityOneSpeed: "slow",
      activityOneTime: 60,
      activityOneCurrentTime: 60,
      activityTwoIntensity: "high",
      activityTwoCurrentTime: 1200,
      activityThreeType: "patterns",
      activityThreeSpeed: "fast",
      activityThreeTime: 60,
      activityThreeCurrentTime: 60,
      pretestScore: 100,
      posttestScore: 100,
    ),
  ];

  Map<DateTime, Color?> sessionsToDateColorsMap() {
    Map<DateTime, Color?> dateColorsMap = {};

    for (var sesh in sessions) {
      final List<bool> conditions = [
        sesh.pretestScore != null,
        sesh.activityOneCurrentTime >= sesh.activityOneTime,
        sesh.activityTwoCurrentTime >= 1200,
        sesh.activityThreeCurrentTime >= sesh.activityThreeTime,
        sesh.posttestScore != null,
      ];

      if (conditions[0] && conditions[1] && conditions[2] && conditions[3] && conditions[4]) {
        dateColorsMap[sesh.date] = const Color.fromRGBO(0, 128, 0, 1.0);
      } else if (conditions[0] && conditions[1] && conditions[2] && conditions[3]) {
        dateColorsMap[sesh.date] = const Color.fromRGBO(32, 160, 32, 1.0);
      } else if (conditions[0] && conditions[1] && conditions[2]) {
        dateColorsMap[sesh.date] = const Color.fromRGBO(64, 128, 64, 1.0);
      } else if (conditions[0] && conditions[1]) {
        dateColorsMap[sesh.date] = const Color.fromRGBO(96, 192, 96, 1.0);
      } else if (conditions[0]) {
        dateColorsMap[sesh.date] = const Color.fromRGBO(128, 255, 128, 1.0);
      } else {
        dateColorsMap[sesh.date] = null;
      }
    }

    return dateColorsMap;
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
        TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2024, 12, 31),
          focusedDay: DateTime.now(),
          onDaySelected: (selectedDay, focusedDay) {
            _showDateDialog(context, selectedDay);
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
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
      ],
    );
  }

  void _showDateDialog(BuildContext context, DateTime selectedDay) {
    final sesh = sessions.firstWhere(
      (session) => session.date == selectedDay,
      orElse: () => Session.empty(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DateFormat.yMMMMd().format(selectedDay)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Pretest score: ${sesh.pretestScore ?? "TBD"}%"),
              Text("Activity 1 time: ${secToMinSec(sesh.activityOneCurrentTime.toDouble())}"),
              Text("Activity 2 time: ${secToMinSec(sesh.activityTwoCurrentTime.toDouble())}"),
              Text("Activity 3 time: ${secToMinSec(sesh.activityThreeCurrentTime.toDouble())}"),
              Text("Posttest score: ${sesh.posttestScore ?? "TBD"}%"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
