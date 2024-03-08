import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          onPressed: () => _onTestingButtonPressed(context),
          child: const Text('Pretest'),
        ),
      ],
    );
  }

  void _onTestingButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Testing');
  }
}
