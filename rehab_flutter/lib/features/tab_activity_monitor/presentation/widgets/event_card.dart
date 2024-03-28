import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/domain/enums/event_enum.dart';

class EventCard extends StatelessWidget {
  final bool isCompleted;
  final double? leftValue;
  final String rightValue;
  final EventType eventType;

  const EventCard({
    super.key,
    required this.isCompleted,
    required this.leftValue,
    required this.rightValue,
    required this.eventType,
  });

  Widget getLeftWidget(double? leftValue, EventType eventType) {
    if (eventType == EventType.test) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: leftValue!.toStringAsFixed(0),
              style: darkTextTheme().headlineMedium,
            ),
            TextSpan(
              text: '%',
              style: darkTextTheme().headlineSmall,
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: 68,
      blur: 4,
      color: Colors.white.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            ...leftValue == null
                ? [
                    Expanded(
                      child: Row(
                        children: [
                          Radio(
                            value: isCompleted,
                            groupValue: true,
                            onChanged: (value) {},
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              return (isCompleted)
                                  ? const Color(0xff01FF99)
                                  : Colors.white;
                            }),
                          ),
                          Expanded(
                            child: Text(
                              rightValue,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: darkTextTheme().headlineSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Radio(
                            value: isCompleted,
                            groupValue: true,
                            onChanged: (value) {},
                            activeColor: const Color(0xff01FF99),
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              return (isCompleted)
                                  ? const Color(0xff01FF99)
                                  : Colors.white;
                            }),
                          ),
                          Expanded(
                            child: getLeftWidget(leftValue, eventType),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 2,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          rightValue,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: darkTextTheme().headlineSmall,
                        ),
                      ),
                    ),
                  ],
          ],
        ),
      ),
    );
  }
}
