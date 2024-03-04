import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
      ),
      body: Column(
        children: [
          AppButton(
            onPressed: () => _onLoginButtonPressed(context),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _onLoginButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Login');
  }
}
