import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/domain/enums/event_enum.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/widgets/event_card.dart';

class EventList extends StatelessWidget {
  final Color dayColor;
  final DateTime selectedDay;
  final Session? currentSession;
  final bool isTherapistView;

  const EventList({
    super.key,
    required this.dayColor,
    required this.selectedDay,
    required this.currentSession,
    this.isTherapistView = false,
  });

  String typeToString(StandardTherapy type) {
    switch (type) {
      case StandardTherapy.pod:
        return "point discrimination";
      case StandardTherapy.ptd:
        return "pattern discrimination";
      case StandardTherapy.ttd:
        return "texture discrimination";
      case StandardTherapy.bms:
        return "basic music stimulation";
      case StandardTherapy.ims:
        return "intermediate music stimulation";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedDayActivities = "";
    List<bool> conditions = [];

    if (currentSession != null) {
      conditions = currentSession!.getDayActivitiesConditions(formatDateMMDDYYYY(selectedDay));
      selectedDayActivities = currentSession!.getDayActivities(formatDateMMDDYYYY(selectedDay))!;
    }

    return GlassContainer(
      shadowStrength: 2,
      shadowColor: Colors.black,
      blur: 4,
      color: Colors.white.withValues(alpha: 0.25),
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getDayOfWeek(selectedDay.weekday),
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          selectedDay.day.toString(),
                          style: const TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              currentSession == null
                  ? Text(
                      "${isTherapistView ? "This user has" : "You have"} no sessions for today",
                      style: darkTextTheme().headlineSmall,
                      textAlign: TextAlign.center,
                    )
                  : Column(
                      children: [
                        // EventCard(
                        //   isCompleted: conditions[0],
                        //   // leftValue: currentSession!.pretestScore ?? 0,
                        //   leftValue: 0,
                        //   rightValue: "Take the Pretest",
                        //   eventType: EventType.test,
                        // ),
                        // const SizedBox(height: 16),
                        EventCard(
                          isCompleted: conditions[0],
                          leftValue: null,
                          rightValue: "Do an intensity-${currentSession!.getStandardOneIntensity(selectedDayActivities)} ${typeToString(currentSession!.getStandardOneType(selectedDayActivities))} session",
                          eventType: EventType.timed,
                        ),
                        const SizedBox(height: 16),
                        EventCard(
                          isCompleted: conditions[1],
                          leftValue: null,
                          rightValue: "Complete an intensity-${currentSession!.getStandardOneIntensity(selectedDayActivities)} passive therapy session",
                          eventType: EventType.timed,
                        ),
                        const SizedBox(height: 16),
                        EventCard(
                          isCompleted: conditions[2],
                          leftValue: null,
                          rightValue: "Do an intensity-${currentSession!.getStandardTwoIntensity(selectedDayActivities)} ${typeToString(currentSession!.getStandardTwoType(selectedDayActivities))} session",
                          eventType: EventType.timed,
                        ),
                        // const SizedBox(height: 16),
                        // EventCard(
                        //   isCompleted: conditions[4],
                        //   // leftValue: currentSession!.posttestScore ?? 0,
                        //   leftValue: 0,
                        //   rightValue: "Take the Posttest",
                        //   eventType: EventType.test,
                        // ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
