import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_state.dart';
import 'package:rehab_flutter/core/data_sources/registration_provider.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_therapist_data.dart';

class RegisterTherapist extends StatefulWidget {
  const RegisterTherapist({super.key});

  @override
  State<RegisterTherapist> createState() => _RegisterTherapistState();
}

class _RegisterTherapistState extends State<RegisterTherapist> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _cityController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final List<String> _availableGenders = availableGenders;
  String? _currentGender;

  int _currentStep = 1;

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
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
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _birthdateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_currentStep == 1) {
                    Navigator.of(context).pop();
                  } else {
                    _previousStep();
                  }
                },
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _getStepTitle(),
                  //"Sign Up As Therapist",
                  style: darkTextTheme().headlineLarge,
                ),
                Text(
                  _getStepSubitle(),
                  //"Create an account to get started",
                  style: darkTextTheme().headlineSmall,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF01FF99),
                    Color(0xFF128BED),
                    Color(0xFF16478B),
                  ],
                  stops: [0.0, 0.8, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1:
        return 'Sign Up';
      case 2:
        return 'Personal Information';
      case 3:
        return 'Create a Password';
      default:
        return 'Sign Up';
    }
  }

  String _getStepSubitle() {
    switch (_currentStep) {
      case 1:
        return 'Create an account to get started.';
      case 2:
        return 'Your information is needed to verify your Identity.';
      case 3:
        return 'Secure your Account with a Strong Password.';
      default:
        return 'Create an account to get started.';
    }
  }

  List<Widget> _buildFormFields() {
    switch (_currentStep) {
      case 1:
        return _buildSignUpFields();
      case 2:
        return _buildPersonalInfoFields();
      case 3:
        return _buildPasswordFields();
      default:
        return _buildSignUpFields();
    }
  }

  Widget _buildBody() {
    return BlocConsumer<TherapistBloc, TherapistState>(
      listener: (context, state) {
        if (state is TherapistNone && state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
        if (state is TherapistDone) {
          BlocProvider.of<TherapistBloc>(context)
              .add(const ResetTherapistEvent());
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is TherapistLoading) {
          return const Center(
              child: CupertinoActivityIndicator(color: Colors.white));
        }
        if (state is TherapistNone || state is TherapistDone) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GlassContainer(
                          blur: 4,
                          color: Colors.white.withOpacity(0.25),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Column(
                                  children: _buildFormFields(),
                                ),
                                Visibility(
                                  visible: _currentStep != 3,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      const Text(
                                        'or Login with',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Sailec Light',
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Theme(
                                            data: loginButtonTheme,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.apple),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Theme(
                                            data: loginButtonTheme,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  Icons.one_x_mobiledata),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Theme(
                                            data: loginButtonTheme,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.facebook),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: darkTextTheme().headlineSmall,
                          ),
                          Theme(
                            data: signupButtonTheme,
                            child: TextButton(
                              onPressed: () => _onLoginButtonPressed(context),
                              child: const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  List<Widget> _buildSignUpFields() {
    return [
      Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            decoration: customInputDecoration.copyWith(
              labelText: 'First Name',
              hintText: 'Enter your First Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _lastNameController,
            decoration: customInputDecoration.copyWith(
              labelText: 'Last Name',
              hintText: 'Enter your Last Name',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: customInputDecoration.copyWith(
              labelText: 'Email',
              hintText: 'Enter your Email Address',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Theme(
              data: darkButtonTheme,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _nextStep();
                  }
                },
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildPersonalInfoFields() {
    return [
      Column(
        children: [
          DropdownButtonFormField<String>(
            value: _currentGender,
            decoration: customInputDecoration.copyWith(
              labelText: 'Select Gender',
            ),
            onChanged: (String? newValue) {
              setState(() {
                _currentGender = newValue!;
              });
            },
            items:
                _availableGenders.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return 'Please select a gender';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _phoneNumberController,
            decoration: customInputDecoration.copyWith(
              labelText: 'Phone Number',
              hintText: 'Enter your Phone Number',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _cityController,
            decoration: customInputDecoration.copyWith(
              labelText: 'Location',
              hintText: 'Enter your Location',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your city';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => _selectDate(context),
            child: IgnorePointer(
              child: TextFormField(
                controller: _birthdateController,
                decoration: customInputDecoration.copyWith(
                  labelText: 'Birthdate',
                  hintText: 'Birthdate (YYY-MM-DD)',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your birthdate';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _licenseNumberController,
            decoration: customInputDecoration.copyWith(
              labelText: 'License Number',
              hintText: 'Enter your License Number',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your license number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Theme(
              data: darkButtonTheme,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _nextStep();
                  }
                },
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildPasswordFields() {
    return [
      Column(
        children: [
          TextFormField(
            controller: _passwordController,
            decoration: customInputDecoration.copyWith(
              labelText: 'Password',
              hintText: 'Enter your Password',
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
          TextFormField(
            controller: _confirmPasswordController,
            decoration: customInputDecoration.copyWith(
              labelText: 'Confirm Password',
              hintText: 'Confirm your Password',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Theme(
              data: darkButtonTheme,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerTherapist();
                  }
                },
                child: const Text('Sign Up'),
              ),
            ),
          ),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text: 'By clicking Sign Up, you agree to our ',
              style: darkTextTheme().headlineSmall,
              children: [
                TextSpan(
                  text: 'terms of services',
                  style: darkTextTheme().displaySmall,
                ),
                const TextSpan(
                  text: ' and ',
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: darkTextTheme().displaySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  void _registerTherapist() {
    // Convert the birthdate from String to DateTime
    DateTime? birthdate =
        DateFormat('yyyy-MM-dd').parseStrict(_birthdateController.text);

    // Create the RegisterData instance with all fields
    RegisterTherapistData registerData = RegisterTherapistData(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      city: _cityController.text,
      licenseNumber: _licenseNumberController.text,
      gender: _currentGender!,
      birthDate: birthdate,
    );

    // Dispatch the event to the bloc
    BlocProvider.of<TherapistBloc>(context)
        .add(RegisterTherapistEvent(registerData));
  }

  void _onLoginButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Login');
  }
}
