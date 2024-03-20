// import 'package:flutter/material.dart';
// import 'package:rehab_flutter/core/entities/session.dart';
// import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/calendar.dart';
// import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/event_list.dart';
// import 'package:table_calendar/table_calendar.dart';

// class ActivityMonitor extends StatefulWidget {
//   const ActivityMonitor({super.key});

//   @override
//   State<ActivityMonitor> createState() => _ActivityMonitorState();
// }

// class _ActivityMonitorState extends State<ActivityMonitor> {
//   late Session currentSession;
//   late Map<DateTime, Color?> dateColorsMap;
//   CalendarFormat _calendarFormat = CalendarFormat.week;
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay = DateTime.now();

//   // Sample data
//   final List<Session> sessions = [
//     Session(
//       sessionId: "session_1",
//       planId: "plan_1",
//       date: DateTime.utc(2024, 3, 7),
//       activityOneType: "Texture Therapy",
//       activityOneSpeed: "slow",
//       activityOneTime: 60,
//       activityOneCurrentTime: 60,
//       activityTwoIntensity: "high",
//       activityTwoCurrentTime: 1200,
//       activityThreeType: "Pattern Therapy",
//       activityThreeSpeed: "fast",
//       activityThreeTime: 60,
//       activityThreeCurrentTime: 60,
//       pretestScore: 100,
//       posttestScore: 100,
//     ),
//     Session(
//       sessionId: "session_2",
//       planId: "plan_1",
//       date: DateTime.utc(2024, 3, 8),
//       activityOneType: "Texture Therapy",
//       activityOneSpeed: "slow",
//       activityOneTime: 60,
//       activityOneCurrentTime: 0,
//       activityTwoIntensity: "high",
//       activityTwoCurrentTime: 0,
//       activityThreeType: "Pattern Therapy",
//       activityThreeSpeed: "fast",
//       activityThreeTime: 60,
//       activityThreeCurrentTime: 0,
//       pretestScore: 95,
//       posttestScore: null,
//     ),
//   ];

//   List<bool> getEventConditions(Session session) {
//     return [
//       session.pretestScore != null,
//       session.activityOneCurrentTime >= session.activityOneTime,
//       session.activityTwoCurrentTime >= 1200,
//       session.activityThreeCurrentTime >= session.activityThreeTime,
//       session.posttestScore != null,
//     ];
//   }

//   Map<DateTime, Color?> sessionsToDateColorsMap() {
//     Map<DateTime, Color?> dateColorsMap = {};

//     for (var sesh in sessions) {
//       final List<bool> conditions = getEventConditions(sesh);

//       if (conditions[0] && conditions[1] && conditions[2] && conditions[3] && conditions[4]) {
//         dateColorsMap[sesh.date] = const Color.fromRGBO(0, 128, 0, 1.0);
//       } else if (conditions[0] && conditions[1] && conditions[2] && conditions[3]) {
//         dateColorsMap[sesh.date] = const Color.fromRGBO(32, 160, 32, 1.0);
//       } else if (conditions[0] && conditions[1] && conditions[2]) {
//         dateColorsMap[sesh.date] = const Color.fromRGBO(64, 128, 64, 1.0);
//       } else if (conditions[0] && conditions[1]) {
//         dateColorsMap[sesh.date] = const Color.fromRGBO(96, 192, 96, 1.0);
//       } else if (conditions[0]) {
//         dateColorsMap[sesh.date] = const Color.fromRGBO(128, 255, 128, 1.0);
//       } else {
//         dateColorsMap[sesh.date] = null;
//       }
//     }

//     return dateColorsMap;
//   }

//   bool _selectedDayPredicate(DateTime day) {
//     return isSameDay(_selectedDay, day);
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = selectedDay;
//       _focusedDay = focusedDay;
//       currentSession = sessions.firstWhere(
//         (session) => session.date == _selectedDay,
//         orElse: () => Session.empty(),
//       );
//     });
//   }

//   void _onPageChanged(DateTime focusedDay) {
//     _focusedDay = focusedDay;
//   }

//   void _onToggleFormat() {
//     setState(() {
//       _calendarFormat = _calendarFormat == CalendarFormat.week ? CalendarFormat.month : CalendarFormat.week;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     dateColorsMap = sessionsToDateColorsMap();
//     currentSession = sessions.firstWhere(
//       (session) => session.date == _selectedDay,
//       orElse: () => Session.empty(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Activity Monitor",
//           style: TextStyle(fontSize: 32),
//         ),
//         const Text(
//           "Monthly Progress",
//           style: TextStyle(fontSize: 16),
//         ),
//         const SizedBox(height: 32),
//         Calendar(
//           dateColorsMap: dateColorsMap,
//           calendarFormat: _calendarFormat,
//           focusedDay: _focusedDay,
//           selectedDay: _selectedDay,
//           selectedDayPredicate: _selectedDayPredicate,
//           onDaySelected: _onDaySelected,
//           onPageChanged: _onPageChanged,
//           onToggleFormat: _onToggleFormat,
//         ),
//         const SizedBox(height: 32),
//         Expanded(
//           child: EventList(
//             dayColor: dateColorsMap[currentSession.date] ?? Colors.white,
//             selectedDay: _selectedDay,
//             currentSession: currentSession,
//             conditions: getEventConditions(currentSession),
//           ),
//         ),
//       ],
//     );
//   }
// }
