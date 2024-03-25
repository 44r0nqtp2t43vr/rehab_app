import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserNone && state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
        if (state is UserDone) {
          Navigator.pushNamed(context, '/BluetoothConnect');
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is UserNone || state is UserDone) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
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
                      onPressed: () => _onLogsTap(context),
                      child: const Text('LOGS'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void _onPassiveButton(BuildContext context) {
    Navigator.pushNamed(context, '/Test');
  }

  void _onLoginButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      BlocProvider.of<UserBloc>(context)
          .add(LoginEvent(LoginData(email: email, password: password)));
    }
  }

  void _onSignUpButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Register');
  }

  void _onLogsTap(BuildContext context) {
    Navigator.pushNamed(context, '/LogsScreen');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
