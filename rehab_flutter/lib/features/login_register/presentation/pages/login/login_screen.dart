import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          AppButton(
            onPressed: () => _onLoginButtonPressed(context),
            child: const Text('Login'),
          ),
          AppButton(
            onPressed: () => _onSignUpButtonPressed(context),
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }

  void _onLoginButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/BluetoothConnect');
  }

  void _onSignUpButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Register');
  }
}
