import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class MiniCalendar extends StatelessWidget {
  final AppUser? user;

  const MiniCalendar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _onPlanSelectionButtonPressed(context),
          child: const Text('Select Plan'),
        ),
        ElevatedButton(
          onPressed: () => _onTodaysSessionPressed(context),
          child: const Text('Today\'s Session'),
        )
      ],
    );
  }

  void _onTodaysSessionPressed(BuildContext context) {
    Navigator.pushNamed(context, '/TodaysSession');
  }

  void _onPlanSelectionButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PlanSelection');
  }
}
