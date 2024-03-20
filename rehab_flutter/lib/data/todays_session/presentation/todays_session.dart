import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';

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

          return FutureBuilder<DocumentSnapshot>(
            future: _fetchTodaySession(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.data() == null) {
                return Center(child: Text("No session found for today."));
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              final pretestScore =
                  data['pretestScore']?.toString() ?? 'Not available';
              final standardOneType =
                  data['standardOneType'] ?? 'Not available';
              final standardTwoType =
                  data['standardTwoType'] ?? 'Not available';
              final passiveIntensity =
                  data['passiveIntensity'] ?? 'Not available';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's routine:",
                        style: Theme.of(context).textTheme.headline5),
                    SizedBox(height: 20),
                    Text("Pretest Score: $pretestScore"),
                    Text("Standard One: $standardOneType"),
                    Text("Passive Intensity: $passiveIntensity"),
                    Text("Standard Two: $standardTwoType"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> _fetchTodaySession(String userId) async {
    final DateTime now = DateTime.now();
    // Start of today
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    // End of today
    final DateTime endOfDay =
        DateTime(now.year, now.month, now.day, 23, 59, 59);

    final String activePlanId = await _fetchActivePlanId(userId);

    // Adjust the query to look for sessions within the date range of today
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('plans')
        .doc(activePlanId)
        .collection('sessions')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first;
    } else {
      throw Exception("No session found for today.");
    }
  }

  Future<String> _fetchActivePlanId(String userId) async {
    // Fetch the active plan ID
    final planSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('plans')
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (planSnapshot.docs.isNotEmpty) {
      return planSnapshot.docs.first.id; // Return the active plan ID
    } else {
      throw Exception("No active plan found.");
    }
  }
}
