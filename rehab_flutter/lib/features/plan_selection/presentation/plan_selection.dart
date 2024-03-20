import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/session.dart'; // Assuming this is your Session entity
import 'package:rehab_flutter/core/entities/plan.dart';

class PlanSelection extends StatefulWidget {
  @override
  _PlanSelectionState createState() => _PlanSelectionState();
}

class _PlanSelectionState extends State<PlanSelection> {
  Future<void> _selectPlan(String planName) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user logged in.")),
      );
      return;
    }

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

    final DateTime startDate = DateTime.now();
    final DateTime endDate = startDate.add(Duration(days: daysToAdd));

    // Assuming sequential naming without checking Firestore. This needs proper management.
    final plansCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('plans');
    final int planNumber = (await plansCollection.get()).docs.length + 1;
    final String planDocumentName = 'plan$planNumber';

    final planData = {
      'planId': planDocumentName,
      'planName': planName,
      'startDate': startDate,
      'endDate': endDate,
      'session_count': daysToAdd,
      'isActive': true,
    };

    await plansCollection.doc(planDocumentName).set(planData).then((_) async {
      print(
          'Plan $planName created for user $userId with ID $planDocumentName');

      // Create sessions
      for (int i = 0; i < daysToAdd; i++) {
        DateTime sessionDate = startDate.add(Duration(days: i));
        final String sessionDocumentName = 'session${i + 1}';
        Session session = Session(
          sessionId: sessionDocumentName,
          planId: planDocumentName,
          date: sessionDate,
          standardOneType: '',
          standardOneIntensity: '',
          isStandardOneDone: false,
          passiveIntensity: '',
          isPassiveDone: false,
          standardTwoType: '',
          standardTwoIntensity: '',
          isStandardTwoDone: false,
          pretestScore: null,
          posttestScore: null,
        );

        await plansCollection
            .doc(planDocumentName)
            .collection('sessions')
            .doc(sessionDocumentName)
            .set(session.toMap());
      }

      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create plan: $error")),
      );
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
