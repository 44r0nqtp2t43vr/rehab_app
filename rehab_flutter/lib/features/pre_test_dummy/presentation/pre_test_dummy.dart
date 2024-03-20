import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PreTestDummy extends StatefulWidget {
  @override
  _PreTestDummyState createState() => _PreTestDummyState();
}

class _PreTestDummyState extends State<PreTestDummy> {
  final TextEditingController _controller = TextEditingController();

  final List<String> therapyTypes = [
    'pianoTiles',
    'musicVisualizer',
    'actuatorTherapy',
    'patternTherapy',
    'textureTherapy',
  ];

  void _submit() async {
    final score = double.tryParse(_controller.text);
    if (score == null || score < 0 || score > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please enter a valid score between 0 and 100.")),
      );
      return;
    }

    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user logged in.")),
      );
      return;
    }

    final Random random = Random();
    List<String> selectedTherapies = List.of(therapyTypes)..shuffle(random);
    String standardOneType = selectedTherapies[0];
    String standardTwoType = selectedTherapies[1]; // Ensures different types

    // Determine the session category based on the score
    String intensityLevel = ((score / 20).ceil().clamp(1, 5)).toString();

    // Update session details
    updateSessionWithDetails(
        userId, score, standardOneType, standardTwoType, intensityLevel);
  }

  Future<void> updateSessionWithDetails(
      String? userId,
      double score,
      String standardOneType,
      String standardTwoType,
      String intensityLevel) async {
    final DateTime today = DateTime.now();
    final DateTime startOfDay = DateTime(today.year, today.month, today.day);
    final DateTime endOfDay =
        DateTime(today.year, today.month, today.day, 23, 59, 59);

    try {
      // Identify the active plan
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('plans')
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No active plan found.")),
        );
        return;
      }

      final activePlanId = querySnapshot.docs.first.id;

      // Fetch sessions for the current date within the active plan
      final sessionSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('plans')
          .doc(activePlanId)
          .collection('sessions')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThanOrEqualTo: endOfDay)
          .get();

      if (sessionSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No session found for today.")),
        );
        return;
      }

      // Assuming we update the first session of the day
      final sessionDoc = sessionSnapshot.docs.first;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('plans')
          .doc(activePlanId)
          .collection('sessions')
          .doc(sessionDoc.id)
          .update({
        'pretestScore': score,
        'standardOneType': standardOneType,
        'standardOneIntensity': intensityLevel,
        'standardTwoType': standardTwoType,
        'standardTwoIntensity': intensityLevel,
        'passiveIntensity': intensityLevel,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Session details updated based on pretest score.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update session: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre Test Dummy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter something'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
