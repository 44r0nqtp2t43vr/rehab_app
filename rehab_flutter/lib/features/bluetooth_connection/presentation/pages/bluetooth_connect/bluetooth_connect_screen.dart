import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/injection_container.dart';

class BluetoothConnectScreen extends StatelessWidget {
  const BluetoothConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haplos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => _onSkip(context),
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures the GestureDetector is as large as its parent
        onTap: () => _onBlueToothScreenTap(context),
        child: const Center(
          child: Text(
            'Welcome to Haplos!\nTap the screen to set up your gloves.',
            textAlign: TextAlign.center, // Center-align the text
          ),
        ),
      ),
    );
  }

  void _onBlueToothScreenTap(BuildContext context) {
    Navigator.pushNamed(context, '/BluetoothScreen');
  }

  void _onSkip(BuildContext context) {
    sl<NavigationController>().setTab(TabEnum.home);
    Navigator.pushNamed(context, '/MainScreen');
  }
}
