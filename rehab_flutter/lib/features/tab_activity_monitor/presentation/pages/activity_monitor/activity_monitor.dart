import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/domain/enums/event_enum.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/event_card.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityMonitor extends StatefulWidget {
  const ActivityMonitor({super.key});

  @override
  State<ActivityMonitor> createState() => _ActivityMonitorState();
}

class _ActivityMonitorState extends State<ActivityMonitor> {
  late Session currentSession;
  late Map<DateTime, Color?> dateColorsMap;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Sample data
  final List<Session> sessions = [
    Session(
      sessionId: "session_1",
      planId: "plan_1",
      date: DateTime.utc(2024, 3, 7),
      activityOneType: "Texture Therapy",
      activityOneSpeed: "slow",
      activityOneTime: 60,
      activityOneCurrentTime: 60,
      activityTwoIntensity: "high",
      activityTwoCurrentTime: 1200,
      activityThreeType: "Pattern Therapy",
      activityThreeSpeed: "fast",
      activityThreeTime: 60,
      activityThreeCurrentTime: 60,
      pretestScore: 100,
      posttestScore: 100,
    ),
    Session(
      sessionId: "session_2",
      planId: "plan_1",
      date: DateTime.utc(2024, 3, 8),
      activityOneType: "Texture Therapy",
      activityOneSpeed: "slow",
      activityOneTime: 60,
      activityOneCurrentTime: 0,
      activityTwoIntensity: "high",
      activityTwoCurrentTime: 0,
      activityThreeType: "Pattern Therapy",
      activityThreeSpeed: "fast",
      activityThreeTime: 60,
      activityThreeCurrentTime: 0,
      pretestScore: 95,
      posttestScore: null,
    ),
  ];

  List<bool> getEventConditions(Session session) {
    return [
      session.pretestScore != null,
      session.activityOneCurrentTime >= session.activityOneTime,
      session.activityTwoCurrentTime >= 1200,
      session.activityThreeCurrentTime >= session.activityThreeTime,
      session.posttestScore != null,
    ];
  }

  Map<DateTime, Color?> sessionsToDateColorsMap() {
    Map<DateTime, Color?> dateColorsMap = {};

    for (var sesh in sessions) {
      final List<bool> conditions = getEventConditions(sesh);

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

  bool _selectedDayPredicate(DateTime day) {
    return isSameDay(_selectedDay, day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      currentSession = sessions.firstWhere(
        (session) => session.date == _selectedDay,
        orElse: () => Session.empty(),
      );
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
  }

  @override
  void initState() {
    super.initState();
    dateColorsMap = sessionsToDateColorsMap();
    currentSession = sessions.firstWhere(
      (session) => session.date == _selectedDay,
      orElse: () => Session.empty(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conditions = getEventConditions(currentSession);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Activity Monitor",
          style: TextStyle(fontSize: 32),
        ),
        const Text(
          "Monthly Progress",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 32),
        Container(
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
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: _selectedDayPredicate,
                onDaySelected: _onDaySelected,
                onPageChanged: _onPageChanged,
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
                icon: Icon(_calendarFormat == CalendarFormat.week ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                onPressed: () {
                  setState(() {
                    _calendarFormat = _calendarFormat == CalendarFormat.week ? CalendarFormat.month : CalendarFormat.week;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 44,
                          decoration: BoxDecoration(
                            color: dateColorsMap[currentSession.date],
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getDayOfWeek(_selectedDay.weekday),
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                _selectedDay.day.toString(),
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    currentSession.date == DateTime(0)
                        ? const Text("You have no sessions for today")
                        : Column(
                            children: [
                              EventCard(
                                isCompleted: conditions[0],
                                leftValue: currentSession.pretestScore ?? 0,
                                rightValue: "Take the Pretest",
                                eventType: EventType.test,
                              ),
                              const SizedBox(height: 16),
                              EventCard(
                                isCompleted: conditions[1],
                                leftValue: currentSession.activityOneCurrentTime.toDouble(),
                                rightValue: "Do a ${currentSession.activityOneSpeed} ${currentSession.activityOneType} session for at least ${secToMinSec(currentSession.activityOneTime.toDouble())}",
                                eventType: EventType.timed,
                              ),
                              const SizedBox(height: 16),
                              EventCard(
                                isCompleted: conditions[2],
                                leftValue: currentSession.activityTwoCurrentTime.toDouble(),
                                rightValue: "Complete a 20-minute ${currentSession.activityTwoIntensity}-intensity passive therapy session",
                                eventType: EventType.timed,
                              ),
                              const SizedBox(height: 16),
                              EventCard(
                                isCompleted: conditions[3],
                                leftValue: currentSession.activityThreeCurrentTime.toDouble(),
                                rightValue: "Do a ${currentSession.activityThreeSpeed} ${currentSession.activityThreeType} session for at least ${secToMinSec(currentSession.activityThreeTime.toDouble())}",
                                eventType: EventType.timed,
                              ),
                              const SizedBox(height: 16),
                              EventCard(
                                isCompleted: conditions[4],
                                leftValue: currentSession.posttestScore ?? 0,
                                rightValue: "Take the Posttest",
                                eventType: EventType.test,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // void _showDateDialog(BuildContext context, DateTime selectedDay) {
  //   final sesh = sessions.firstWhere(
  //     (session) => session.date == selectedDay,
  //     orElse: () => Session.empty(),
  //   );

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(DateFormat.yMMMMd().format(selectedDay)),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text("Pretest score: ${sesh.pretestScore ?? "TBD"}%"),
  //             Text("Activity 1 time: ${secToMinSec(sesh.activityOneCurrentTime.toDouble())}"),
  //             Text("Activity 2 time: ${secToMinSec(sesh.activityTwoCurrentTime.toDouble())}"),
  //             Text("Activity 3 time: ${secToMinSec(sesh.activityThreeCurrentTime.toDouble())}"),
  //             Text("Posttest score: ${sesh.posttestScore ?? "TBD"}%"),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
