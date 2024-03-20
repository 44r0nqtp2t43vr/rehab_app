import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';

class PlanSelection extends StatefulWidget {
  @override
  _PlanSelectionState createState() => _PlanSelectionState();
}

class _PlanSelectionState extends State<PlanSelection> {
  Future<void> _selectPlan(String planName) async {
    // Retrieve the current user's ID
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No user logged in."),
      ));
      return;
    }

    // Update the user's plan in Firestore
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'plan': planName,
    }).then((_) {
      print('Plan updated to $planName for user $userId');
      // Pop the screen after successfully updating the plan
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update plan: $error"),
      ));
    });
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
          final userId = state.currentUser?.userId;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(userId!), // Displaying the user ID for demonstration
                ElevatedButton(
                  onPressed: () => _selectPlan('Plan 1: One Week'),
                  child: Text('Plan 1: One Week'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _selectPlan('Plan 2: One Month'),
                  child: Text('Plan 2: One Month'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _selectPlan('Plan 3: Three Months'),
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
