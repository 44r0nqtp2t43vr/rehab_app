import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          AppButton(
            onPressed: () => _onTherapyButtonPressed(context),
            child: const Text('Therapy'),
          ),
          AppButton(
            onPressed: () => _onProgressButtonPressed(context),
            child: const Text('Progress'),
          ),
          AppButton(
            onPressed: () => _onProfileButtonPressed(context),
            child: const Text('My Profile'),
          ),
        ],
      ),
    );
  }

  void _onTherapyButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Therapy');
  }

  void _onProgressButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Progress');
  }

  void _onProfileButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Profile');
  }
}
