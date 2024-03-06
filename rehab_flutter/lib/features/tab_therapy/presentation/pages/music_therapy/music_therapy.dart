import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/injection_container.dart';

class MusicTherapyScreen extends StatelessWidget {
  final VoidCallback callback;

  const MusicTherapyScreen({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          onPressed: () => _onBackButtonPressed(context),
          child: const Text('Back'),
        ),
        AppButton(
          onPressed: () => _onPianoTilesButtonPressed(context),
          child: const Text('Piano Tiles'),
        ),
        AppButton(
          onPressed: () => _onVisualizerButtonPressed(context),
          child: const Text('Visualizer'),
        ),
      ],
    );
  }

  void _onBackButtonPressed(BuildContext context) {
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.home);
    callback();
  }

  void _onPianoTilesButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/SongSelect');
  }

  void _onVisualizerButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Visualizer');
  }
}
