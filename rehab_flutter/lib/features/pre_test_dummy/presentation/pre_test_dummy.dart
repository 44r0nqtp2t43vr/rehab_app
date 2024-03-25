import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';
import 'package:rehab_flutter/features/pre_test_dummy/pretest_session_generation_data.dart';
import 'package:rehab_flutter/injection_container.dart';

class PreTestDummy extends StatefulWidget {
  @override
  _PreTestDummyState createState() => _PreTestDummyState();
}

class _PreTestDummyState extends State<PreTestDummy> {
  final TextEditingController _controller = TextEditingController();

  void _submit(AppUser user) async {
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

    sl<UserBloc>()
        .add(GenerateSessionEvent(PretestData(user: user, score: score)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre Test Dummy'),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // You can handle state changes here if necessary
        },
        builder: (context, state) {
          // Assuming your UserState has a currentUser field of a custom AppUser type
          AppUser? currentUser = state.currentUser;

          return Padding(
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
                  onPressed:
                      currentUser != null ? () => _submit(currentUser) : null,
                  child: Text('Submit'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void _onActuatorTherapyPressed(BuildContext context) {
  Navigator.pushNamed(context, '/ActuatorTherapy');
}

void _onPianoTilesPressed(BuildContext context) {
  Navigator.pushNamed(context, '/PianoTiles');
}
