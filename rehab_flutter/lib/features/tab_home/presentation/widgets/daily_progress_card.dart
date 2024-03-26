import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/session.dart';

class DailyProgressCard extends StatelessWidget {
  final Session? todaySession;

  const DailyProgressCard({super.key, required this.todaySession});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Container(
            height: 136,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.white),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _onSeeDailyProgress(todaySession, context),
            child: Container(
              height: 32,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white),
              ),
              child: const Center(
                child: Text(
                  "See Daily Progress",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSeeDailyProgress(Session? session, BuildContext context) {
    final List<bool> conditions = session!.getSessionConditions();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Row(
                children: [
                  Icon(
                    Icons.arrow_upward,
                    size: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Progress",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Radio(
                    value: conditions[0],
                    groupValue: true,
                    onChanged: (value) {},
                  ),
                  const Text("Completed Pre-test"),
                ],
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => _onCloseButtonPressed(context),
                child: const Text("CLOSE"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onCloseButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
