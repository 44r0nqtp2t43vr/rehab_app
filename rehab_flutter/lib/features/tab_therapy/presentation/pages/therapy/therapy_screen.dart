import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
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
  void setTabTherapy() {
    setState(() {});
  }

  Widget buildTherapyScreenHome() {
    return Column(
      children: [
        const SizedBox(height: 500),
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
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.music);
    setState(() {});
  }

  void _onCTButtonPressed() {
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.cutaneous);
    setState(() {});
  }
}
