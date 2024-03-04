import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class MusicTherapyScreen extends StatelessWidget {
  const MusicTherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Therapy'),
      ),
      body: Column(
        children: [
          AppButton(
            onPressed: () => _onPianoTilesButtonPressed(context),
            child: const Text('Piano Tiles'),
          ),
          AppButton(
            onPressed: () => _onVisualizerButtonPressed(context),
            child: const Text('Visualizer'),
          ),
        ],
      ),
    );
  }

  void _onPianoTilesButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PianoTilesSongSelect');
  }

  void _onVisualizerButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Visualizer');
  }
}
