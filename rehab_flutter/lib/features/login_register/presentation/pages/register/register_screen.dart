import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
