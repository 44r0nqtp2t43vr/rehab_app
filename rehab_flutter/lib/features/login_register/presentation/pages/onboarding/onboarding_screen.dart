import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/injection_container.dart';

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
          AppButton(
            onPressed: () => _onHomeButtonPressed(context),
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }

  void _onLoginButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Login');
  }

  void _onHomeButtonPressed(BuildContext context) {
    sl<NavigationController>().setTab(TabEnum.home);
    Navigator.pushNamed(context, '/MainScreen');
  }
}
