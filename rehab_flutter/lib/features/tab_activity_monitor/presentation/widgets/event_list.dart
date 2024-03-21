import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/domain/enums/event_enum.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/event_card.dart';

class EventList extends StatelessWidget {
  final Color dayColor;
  final DateTime selectedDay;
  final Session? currentSession;
  final List<bool> conditions;

  const EventList({
    super.key,
    required this.dayColor,
    required this.selectedDay,
    required this.currentSession,
    required this.conditions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      color: dayColor,
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
                          getDayOfWeek(selectedDay.weekday),
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          selectedDay.day.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              currentSession == null
                  ? const Text("You have no sessions for today")
                  : Column(
                      children: [
                        EventCard(
                          isCompleted: conditions[0],
                          leftValue: currentSession!.pretestScore ?? 0,
                          rightValue: "Take the Pretest",
                          eventType: EventType.test,
                        ),
                        const SizedBox(height: 16),
                        conditions[0]
                            ? Column(
                                children: [
                                  EventCard(
                                    isCompleted: conditions[1],
                                    leftValue: null,
                                    rightValue: "Do an intensity-${currentSession!.standardOneIntensity} ${currentSession!.standardOneType} session",
                                    eventType: EventType.timed,
                                  ),
                                  const SizedBox(height: 16),
                                  EventCard(
                                    isCompleted: conditions[2],
                                    leftValue: null,
                                    rightValue: "Complete a 20-minute intensity-${currentSession!.passiveIntensity} passive therapy session",
                                    eventType: EventType.timed,
                                  ),
                                  const SizedBox(height: 16),
                                  EventCard(
                                    isCompleted: conditions[3],
                                    leftValue: null,
                                    rightValue: "Do an intensity-${currentSession!.standardTwoIntensity} ${currentSession!.standardTwoType} session",
                                    eventType: EventType.timed,
                                  ),
                                  const SizedBox(height: 16),
                                  EventCard(
                                    isCompleted: conditions[4],
                                    leftValue: currentSession!.posttestScore ?? 0,
                                    rightValue: "Take the Posttest",
                                    eventType: EventType.test,
                                  ),
                                ],
                              )
                            : const Text("Take the Pretest to determine the next steps for this session"),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
