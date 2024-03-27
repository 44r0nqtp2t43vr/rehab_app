import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/session.dart';

class DailyProgressCard extends StatelessWidget {
  final Session? todaySession;

  const DailyProgressCard({super.key, required this.todaySession});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
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
            child: Center(
              child: Text(
                "${todaySession == null ? 0 : todaySession!.getSessionPercentCompletion().toStringAsFixed(0)}%",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
    if (session == null) {
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
                const Text(
                  "You have no sessions for today",
                  style: TextStyle(
                    fontSize: 12,
                  ),
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
    } else {
      final List<bool> conditions = session.getSessionConditions();
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
                    const Expanded(
                      child: Text("Completed Pre-test"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Radio(
                      value: conditions[1],
                      groupValue: true,
                      onChanged: (value) {},
                    ),
                    const Expanded(
                      child: Text("Completed 1st Standard Session"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Radio(
                      value: conditions[2],
                      groupValue: true,
                      onChanged: (value) {},
                    ),
                    const Expanded(
                      child: Text("Completed Passive Session"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Radio(
                      value: conditions[3],
                      groupValue: true,
                      onChanged: (value) {},
                    ),
                    const Expanded(
                      child: Text("Completed 2nd Standard Session"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Radio(
                      value: conditions[4],
                      groupValue: true,
                      onChanged: (value) {},
                    ),
                    const Expanded(
                      child: Text("Completed Post-test"),
                    ),
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
  }

  void _onCloseButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
