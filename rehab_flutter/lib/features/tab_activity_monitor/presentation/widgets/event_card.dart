import 'package:flutter/material.dart';
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
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const TextSpan(
              text: '%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white),
      ),
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
                          ),
                          Expanded(
                            child: Text(
                              rightValue,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                          ),
                          Expanded(
                            child: getLeftWidget(leftValue, eventType),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1.0,
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
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
