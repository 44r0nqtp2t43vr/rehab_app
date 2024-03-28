import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class ContinueCard extends StatelessWidget {
  final AppUser user;

  const ContinueCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final Plan? currentPlan = user.getCurrentPlan();

    return GestureDetector(
      onTap: () => _onTap(context, currentPlan),
      child: Container(
        height: 124,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "${currentPlan == null ? 0 : currentPlan.getPlanPercentCompletion().toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Therapy Plan",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Overall Progress",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, Plan? currentPlan) {
    if (currentPlan == null) {
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
                    Text(
                      "Select Plan",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
      Session? currentSession = currentPlan.getCurrentSession();
      if (currentSession == null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
        List<bool> conditions = currentSession.getSessionConditions();
        if (!conditions[0]) {
          Navigator.pushNamed(context, '/Testing');
        } else if (!conditions[1]) {
          Navigator.pushNamed(context, '/Testing');
        } else if (!conditions[2]) {
          Navigator.pushNamed(context, '/Testing');
        } else if (!conditions[3]) {
          Navigator.pushNamed(context, '/Testing');
        } else if (!conditions[4]) {
          Navigator.pushNamed(context, '/Testing');
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      "You have completed all sessions today",
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
        }
      }
    }
  }

  void _onCloseButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
