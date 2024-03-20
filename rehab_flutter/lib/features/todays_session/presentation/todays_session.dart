import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/session.dart';

class TodaySessionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Routine'),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // Handle state changes if necessary
        },
        builder: (context, state) {
          final userId = state.currentUser?.userId;

          if (userId == null) {
            return Center(child: Text("User not found."));
          }

          return FutureBuilder<Session>(
            future: _fetchTodaySession(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (!snapshot.hasData) {
                return Center(child: Text("No session found for today."));
              }

              final session = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's routine:",
                        style: Theme.of(context).textTheme.headline5),
                    SizedBox(height: 20),
                    Text(
                        "Pretest Score: ${session.pretestScore ?? 'Not available'}"),
                    Text("Standard One: ${session.standardOneType}"),
                    Text("Passive Intensity: ${session.passiveIntensity}"),
                    Text("Standard Two: ${session.standardTwoType}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<Session> _fetchTodaySession(String userId) async {
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay =
        DateTime(now.year, now.month, now.day, 23, 59, 59);
    final String activePlanId = await _fetchActivePlanId(userId);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('plans')
        .doc(activePlanId)
        .collection('sessions')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      return Session.fromMap(data);
    } else {
      throw Exception("No session found for today.");
    }
  }

  Future<String> _fetchActivePlanId(String userId) async {
    final planSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('plans')
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (planSnapshot.docs.isNotEmpty) {
      return planSnapshot.docs.first.id;
    } else {
      throw Exception("No active plan found.");
    }
  }
}
