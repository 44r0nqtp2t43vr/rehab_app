import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';

class ContinueCard extends StatelessWidget {
  final AppUser user;

  const ContinueCard({super.key, required this.user});

  Future<void> _selectPlan(BuildContext context, String planName, AppUser user) async {
    int daysToAdd;
    switch (planName) {
      case 'One Week':
        daysToAdd = 7;
        break;
      case 'One Month':
        daysToAdd = 30;
        break;
      case 'Three Months':
        daysToAdd = 90;
        break;
      default:
        daysToAdd = 7;
    }
    BlocProvider.of<UserBloc>(context).add(AddPlanEvent(AddPlanData(user: user, planSelected: daysToAdd)));
  }

  @override
  Widget build(BuildContext context) {
    final Plan? currentPlan = user.getCurrentPlan();

    return GestureDetector(
      onTap: () => _onTap(context, user, currentPlan),
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

  void _onTap(BuildContext context, AppUser user, Plan? currentPlan) {
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
                ElevatedButton(
                  onPressed: () => _selectPlan(context, 'One Week', user).then((value) => Navigator.of(context).pop()),
                  child: const Text('Plan 1: One Week'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _selectPlan(context, 'One Month', user).then((value) => Navigator.of(context).pop()),
                  child: const Text('Plan 2: One Month'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _selectPlan(context, 'Three Months', user).then((value) => Navigator.of(context).pop()),
                  child: const Text('Plan 3: Three Months'),
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
