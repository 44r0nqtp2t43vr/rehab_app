import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/injection_container.dart';

class CutaneousTherapyScreen extends StatelessWidget {
  final VoidCallback callback;

  const CutaneousTherapyScreen({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          onPressed: () => _onBackButtonPressed(context),
          child: const Text('Back'),
        ),
        AppButton(
          onPressed: () => _onATButtonPressed(context),
          child: const Text('Actuator Therapy'),
        ),
        AppButton(
          onPressed: () => _onPTButtonPressed(context),
          child: const Text('Pattern Therapy'),
        ),
        AppButton(
          onPressed: () => _onTTButtonPressed(context),
          child: const Text('Texture Therapy'),
        ),
        AppButton(
          onPressed: () => _onSTButtonPressed(context),
          child: const Text('Scrolling Textures'),
        ),
        AppButton(
          onPressed: () => _onSAButtonPressed(context),
          child: const Text('Scrolling Actuators'),
        ),
      ],
    );
  }

  void _onBackButtonPressed(BuildContext context) {
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.home);
    callback();
  }

  void _onATButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/ActuatorTherapy');
  }

  void _onPTButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PatternTherapy');
  }

  void _onTTButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/TextureTherapy');
  }

  void _onSTButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/BgSongSelect');
  }

  void _onSAButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/ScrollActuators');
  }
}
