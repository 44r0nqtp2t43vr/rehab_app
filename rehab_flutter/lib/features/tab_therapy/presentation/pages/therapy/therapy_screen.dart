import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/pages/cutaneous_therapy/cutaneous_therapy.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/pages/music_therapy/music_therapy.dart';
import 'package:rehab_flutter/injection_container.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key});

  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  void setTabTherapy(TabTherapyEnum newTabTherapy) {
    sl<NavigationController>().setTherapyTab(newTabTherapy);
    setState(() {});
  }

  Widget buildTherapyScreenHome() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          onPressed: () => _onMTButtonPressed(),
          child: const Text('Music Therapy'),
        ),
        AppButton(
          onPressed: () => _onCTButtonPressed(),
          child: const Text('Cutaneous Therapy'),
        ),
      ],
    );
  }

  Widget getScreenFromTabTherapy() {
    switch (sl<NavigationController>().currentTherapyTab) {
      case TabTherapyEnum.home:
        return buildTherapyScreenHome();
      case TabTherapyEnum.music:
        return MusicTherapyScreen(callback: setTabTherapy);
      case TabTherapyEnum.cutaneous:
        return CutaneousTherapyScreen(callback: setTabTherapy);
      default:
        return buildTherapyScreenHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return getScreenFromTabTherapy();
  }

  void _onMTButtonPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Music Therapy"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => _onBasicMTButtonPressed(context),
              child: const Text("Basic"),
            ),
            ElevatedButton(
              onPressed: () => _onIntermediateMTButtonPressed(context),
              child: const Text("Intermediate"),
            ),
          ],
        );
      },
    );
  }

  void _onBasicMTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    sl<SongController>().setMTType(MusicTherapy.basic);
    sl<SongController>().setSong(null);
    setTabTherapy(TabTherapyEnum.music);
  }

  void _onIntermediateMTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    sl<SongController>().setMTType(MusicTherapy.intermediate);
    sl<SongController>().setSong(null);
    setTabTherapy(TabTherapyEnum.music);
  }

  void _onCTButtonPressed() {
    setTabTherapy(TabTherapyEnum.cutaneous);
  }
}
