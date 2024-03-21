import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/calendar.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/event_list.dart';
import 'package:table_calendar/table_calendar.dart';

class ActivityMonitor extends StatefulWidget {
  final List<Session> sessions;

  const ActivityMonitor({super.key, required this.sessions});

  @override
  State<ActivityMonitor> createState() => _ActivityMonitorState();
}

class _ActivityMonitorState extends State<ActivityMonitor> {
  late Session currentSelectedSession;
  late Map<String, Color?> dateColorsMap;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<bool> getEventConditions(Session session) {
    return [
      session.pretestScore != null,
      session.isStandardOneDone,
      session.isPassiveDone,
      session.isStandardTwoDone,
      session.posttestScore != null,
    ];
  }

  Map<String, Color?> sessionsToDateColorsMap() {
    Map<String, Color?> dateColorsMap = {};

    for (var sesh in widget.sessions) {
      final String dateString = "${sesh.date.year}${sesh.date.month}${sesh.date.day}";
      final List<bool> conditions = getEventConditions(sesh);

      if (conditions[0] && conditions[1] && conditions[2] && conditions[3] && conditions[4]) {
        dateColorsMap[dateString] = const Color.fromRGBO(0, 128, 0, 1.0);
      } else if (conditions[0] && conditions[1] && conditions[2] && conditions[3]) {
        dateColorsMap[dateString] = const Color.fromRGBO(32, 160, 32, 1.0);
      } else if (conditions[0] && conditions[1] && conditions[2]) {
        dateColorsMap[dateString] = const Color.fromRGBO(64, 128, 64, 1.0);
      } else if (conditions[0] && conditions[1]) {
        dateColorsMap[dateString] = const Color.fromRGBO(96, 192, 96, 1.0);
      } else if (conditions[0]) {
        dateColorsMap[dateString] = const Color.fromRGBO(128, 255, 128, 1.0);
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
    return BlocConsumer<UserBloc, UserState>(
      listener: (BuildContext context, UserState state) {},
      builder: (BuildContext context, UserState state) {
        if (state is UserLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is UserDone) {
          final currentSelectedSessionDateString = "${currentSelectedSession.date.year}${currentSelectedSession.date.month}${currentSelectedSession.date.day}";
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
              const SizedBox(height: 32),
              Expanded(
                child: EventList(
                  dayColor: dateColorsMap[currentSelectedSessionDateString] ?? Colors.white,
                  selectedDay: _selectedDay,
                  currentSession: currentSelectedSession.sessionId.isEmpty ? null : currentSelectedSession,
                  conditions: getEventConditions(currentSelectedSession),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
