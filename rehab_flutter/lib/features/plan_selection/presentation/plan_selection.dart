import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/plan_selection/presentation/add_plan_data.dart';
import 'package:rehab_flutter/injection_container.dart'; // Assuming this is your Session entity

class PlanSelection extends StatefulWidget {
  @override
  _PlanSelectionState createState() => _PlanSelectionState();
}

class _PlanSelectionState extends State<PlanSelection> {
  Future<void> _selectPlan(String planName, AppUser user) async {
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
        daysToAdd = 7; // Default to one week if plan name doesn't match
    }
    sl<UserBloc>()
        .add(AddPlanEvent(AddPlanData(user: user, planSelected: daysToAdd)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Plan'),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // Listener implementation, if needed
        },
        builder: (context, state) {
          AppUser? currentUser = state.currentUser;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(currentUser!
                    .getUserUid()), // Displaying the user ID for demonstration
                ElevatedButton(
                  onPressed: () => _selectPlan('One Week', currentUser),
                  child: Text('Plan 1: One Week'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _selectPlan('One Month', currentUser),
                  child: Text('Plan 2: One Month'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _selectPlan('Three Months', currentUser),
                  child: Text('Plan 3: Three Months'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
