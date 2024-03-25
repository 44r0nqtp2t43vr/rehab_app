import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';

class TodaySessionScreen extends StatelessWidget {
  const TodaySessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Routine'),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // Handle state changes if necessary
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserDone) {
            final Session? todaySession =
                state.currentUser!.getCurrentSession();
            if (todaySession == null) {
              return const Center(child: Text("No session found for today."));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's routine:",
                        style: Theme.of(context).textTheme.headline5),
                    const SizedBox(height: 20),
                    Text(
                        "Pretest Score: ${todaySession.pretestScore ?? 'Not available'}"),
                    Text("Standard One: ${todaySession.standardOneType}"),
                    Text("Passive Intensity: ${todaySession.passiveIntensity}"),
                    Text("Standard Two: ${todaySession.standardTwoType}"),
                    ElevatedButton(
                      // Disable the button if todaySession.isStandardOneDone is true
                      onPressed: todaySession.isStandardOneDone
                          ? null
                          : () => _onStandardPressed(context,
                              _toStandardTherapy(todaySession.standardOneType)),
                      child: Text(todaySession.standardOneType),
                    ),
                    ElevatedButton(
                      // Disable the button if todaySession.isPassiveDone is true
                      onPressed: todaySession.isPassiveDone
                          ? null
                          : () => _onPassiveTherapyPressed(context),
                      child: Text('Start Passive Therapy'),
                      style: ElevatedButton.styleFrom(
                          // Additional styling can go here, if needed
                          ),
                    ),
                    ElevatedButton(
                      // Disable the button if todaySession.isStandardTwoDone is true
                      onPressed: todaySession.isStandardTwoDone
                          ? null
                          : () => _onStandardPressed(context,
                              _toStandardTherapy(todaySession.standardTwoType)),
                      child: Text(todaySession.standardTwoType),
                    ),
                  ],
                ),
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _onStandardPressed(BuildContext context, StandardTherapy therapy) {
    switch (therapy) {
      case StandardTherapy.actuatorTherapy:
        _onActuatorTherapyPressed(context);
        break;
      case StandardTherapy.pianoTiles:
        _onPianoTilesPressed(context);
        break;
      case StandardTherapy.patternTherapy:
        _onPatternPressed(context);
        break;
      case StandardTherapy.textureTherapy:
        _onTexturePressed(context);
        break;

      // Add more cases for other therapy types as needed
      default:
        // Handle any cases that are not explicitly covered, if necessary
        break;
    }
  }

  void _onPassiveTherapyPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PassiveTherapy');
  }

  void _onActuatorTherapyPressed(BuildContext context) {
    Navigator.pushNamed(context, '/ActuatorTherapy');
  }

  void _onPianoTilesPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PianoTiles');
  }

  void _onPatternPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PatternTherapy');
  }

  void _onTexturePressed(BuildContext context) {
    Navigator.pushNamed(context, '/TextureTherapy');
  }

  StandardTherapy _toStandardTherapy(String therapyType) {
    return StandardTherapy.values.firstWhere(
      (e) => e.toString().split('.').last == therapyType,
      orElse: () => throw Exception('Invalid therapy type'),
    );
  }
}
