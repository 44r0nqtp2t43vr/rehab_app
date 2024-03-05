import 'package:flutter/material.dart';

class BluetoothConnectScreen extends StatelessWidget {
  const BluetoothConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haplos'),
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
}
