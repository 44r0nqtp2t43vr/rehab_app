import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              AppButton(
                onPressed: () => _onLoginButtonPressed(),
                child: const Text('Login'),
              ),
              AppButton(
                onPressed: () => _onSignUpButtonPressed(context),
                child: const Text('Sign up'),
              ),
              AppButton(
                onPressed: () => _onPassiveButton(context),
                child: const Text('TEST'),
              ),
              AppButton(
                onPressed: () => _onVisualizerScreenTap(context),
                child: const Text('SKIP'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPassiveButton(BuildContext context) {
    Navigator.pushNamed(context, '/Test');
  }

  void _onLoginButtonPressed() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        // Perform Firebase login
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Directly using this.context after checking for mounted
        // ensures that we are safely referring to the current context.
        if (!mounted) return;
        // If login is successful, navigate to the Bluetooth screen
        Navigator.pushNamed(context, '/BluetoothConnect');
      } catch (e) {
        if (!mounted) return;
        // Use this.context to refer to the current BuildContext
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login: ${e.toString()}')),
        );
      }
    } else {
      if (!mounted) return;
      // Showing an error message using this.context
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  void _onSignUpButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Register');
  }

  void _onBlueToothScreenTap(BuildContext context) {
    Navigator.pushNamed(context, '/BluetoothConnect');
  }

  void _onVisualizerScreenTap(BuildContext context) {
    Navigator.pushNamed(context, '/VisualizerSlider');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
