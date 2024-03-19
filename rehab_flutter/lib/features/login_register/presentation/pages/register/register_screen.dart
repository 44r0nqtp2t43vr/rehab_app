import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/core/bloc/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/user/user_state.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/injection_container.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdateController =
      TextEditingController(); // Consider using a DatePicker
  final Bloc<UserEvent, UserState> userBloc = sl<UserBloc>();

  List<String> _availableConditions = [
    'Condition 1',
    'Condition 2',
    'Condition 3',
  ]; // Populate with real conditions
  List<String> _selectedConditions = [];
  String _currentCondition = 'Condition 1'; // Default or initial condition

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (_, state) {
        if (state is UserLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is UserNone) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: _buildFormFields(),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  List<Widget> _buildFormFields() {
    return [
      TextFormField(
        controller: _firstNameController,
        decoration: const InputDecoration(labelText: 'First Name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your first name';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _lastNameController,
        decoration: const InputDecoration(labelText: 'Last Name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your last name';
          }
          return null;
        },
      ),
      TextFormField(
          controller: _genderController,
          decoration: const InputDecoration(labelText: "Gender"),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter gender';
            }
            return null;
          }),
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(labelText: 'Email'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _passwordController,
        decoration: const InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _confirmPasswordController,
        decoration: const InputDecoration(labelText: 'Confirm Password'),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please confirm your password';
          }
          if (value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _phoneNumberController,
        decoration: const InputDecoration(labelText: 'Phone Number'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _cityController,
        decoration: const InputDecoration(labelText: 'City'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your city';
          }
          return null;
        },
      ),
      InkWell(
        onTap: () => _selectDate(context),
        child: IgnorePointer(
          child: TextFormField(
            controller: _birthdateController,
            decoration: InputDecoration(
              labelText: 'Birthdate (YYYY-MM-DD)',
              hintText: 'Tap to select date',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your birthdate';
              }
              return null;
            },
          ),
        ),
      ),
      DropdownButtonFormField<String>(
        value: _currentCondition,
        decoration: const InputDecoration(labelText: 'Select Condition'),
        onChanged: (String? newValue) {
          setState(() {
            _currentCondition = newValue!;
          });
        },
        items:
            _availableConditions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      ElevatedButton(
        onPressed: _addCondition,
        child: const Icon(Icons.add),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(14),
        ),
      ),
      Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: _selectedConditions
            .map((condition) => Chip(
                  label: Text(condition),
                  onDeleted: () => _removeCondition(condition),
                ))
            .toList(),
      ),
      const SizedBox(height: 20),
      AppButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _registerUser();
          }
        },
        child: const Text('Register'),
      ),
      AppButton(
        onPressed: () => _onLoginButtonPressed(context),
        child: const Text('Already have an account? Login'),
      ),
    ];
  }

  void _addCondition() {
    if (!_selectedConditions.contains(_currentCondition)) {
      setState(() {
        _selectedConditions.add(_currentCondition);
      });
    }
  }

  void _removeCondition(String condition) {
    setState(() {
      _selectedConditions.remove(condition);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        // Update the UI
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _registerUser() {
    // Convert the birthdate from String to DateTime
    DateTime? birthdate =
        DateFormat('yyyy-MM-dd').parseStrict(_birthdateController.text);

    // Create the RegisterData instance with all fields
    RegisterData registerData = RegisterData(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      city: _cityController.text,
      gender:
          _genderController.text, // Assuming gender is included in RegisterData
      birthDate: birthdate,
      conditions: _selectedConditions,
    );

    // Dispatch the event to the bloc
    sl<UserBloc>().add(RegisterEvent(context, registerData));
  }

  void _onLoginButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Login');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
