import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class TherapyScreen extends StatelessWidget {
  const TherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapy'),
      ),
      body: Column(
        children: [
          AppButton(
            onPressed: () => _onMusicTherapyButtonPressed(context),
            child: const Text('Music Therapy'),
          ),
          AppButton(
            onPressed: () => _onCutaneousStimulationButtonPressed(context),
            child: const Text('Cutaneous Stimulation'),
          ),
        ],
      ),
    );
  }

  void _onMusicTherapyButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/MusicTherapy');
  }

  void _onCutaneousStimulationButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/CutaneousStimulation');
  }
}
