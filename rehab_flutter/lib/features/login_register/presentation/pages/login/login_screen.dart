import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patient_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_event.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_bloc.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_event.dart';
import 'package:rehab_flutter/injection_container.dart';

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
      ),
      body: SizedBox.expand(
        child: Container(
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
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserNone) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          } else if (state.data != null && state.data is Admin) {
            BlocProvider.of<AdminBloc>(context).add(GetAdminEvent(state.data));
            sl<NavigationController>().setTab(TabEnum.home);
            Navigator.pushNamed(context, '/AdminMain');
          } else if (state.data != null && state.data is Therapist) {
            BlocProvider.of<TherapistPatientListBloc>(context).add(const ResetTherapistPatientListEvent());
            BlocProvider.of<ViewedTherapistPatientBloc>(context).add(const ResetViewedTherapistPatientEvent());
            BlocProvider.of<TherapistBloc>(context).add(GetTherapistEvent(state.data));
            sl<NavigationController>().setTab(TabEnum.home);
            Navigator.pushNamed(context, '/TherapistMain');
          }
        }
        if (state is UserDone) {
          BlocProvider.of<PatientPlansBloc>(context).add(FetchPatientPlansEvent(state.currentUser!));
          BlocProvider.of<PatientCurrentPlanBloc>(context).add(FetchPatientCurrentPlanEvent(state.currentUser!));
          BlocProvider.of<PatientCurrentSessionBloc>(context).add(FetchPatientCurrentSessionEvent(state.currentUser!));

          Navigator.pushNamed(context, '/BluetoothConnect');
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(
            child: Lottie.asset(
              'assets/lotties/loading-1.json',
              width: 400,
              height: 400,
            ),
          );
        }
        if (state is UserNone || state is UserDone) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/CU. white logo.png',
                          width: MediaQuery.of(context).size.width * 0.55,
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Column(
                        children: [
                          GlassContainer(
                            blur: 4,
                            color: Colors.white.withOpacity(0.25),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: customInputDecoration.copyWith(
                                          labelText: 'Email',
                                          hintText: 'Enter your Email',
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
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: _passwordController,
                                        decoration: customInputDecoration.copyWith(
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
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Theme(
                                          data: textButtonTheme,
                                          child: TextButton(
                                            onPressed: () {},
                                            child: const Text('Forgot Password?'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Theme(
                                          data: darkButtonTheme,
                                          child: ElevatedButton(
                                            onPressed: () => _onLoginButtonPressed(),
                                            child: const Text('Login'),
                                          ),
                                        ),
                                      ),
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
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                              icon: const Icon(Icons.one_x_mobiledata),
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
                                      // AppButton(
                                      //   onPressed: () => _onPassiveButton(context),
                                      //   child: const Text('TEST'),
                                      // ),
                                      // AppButton(
                                      //   onPressed: () => _onLogsTap(context),
                                      //   child: const Text('LOGS'),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: darkTextTheme().headlineSmall,
                              ),
                              Theme(
                                data: signupButtonTheme,
                                child: TextButton(
                                  onPressed: () => _onSignUpButtonPressed(context),
                                  child: const Text('Sign Up'),
                                ),
                              ),
                            ],
                          ),
                          Theme(
                            data: signupButtonTheme,
                            child: TextButton(
                              onPressed: () => _onSignUpTherapistButtonPressed(context),
                              child: const Text('Sign Up as a Therapist'),
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

  void _onLoginButtonPressed() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      BlocProvider.of<UserBloc>(context).add(LoginEvent(LoginData(email: email, password: password)));
    }
  }

  void _onSignUpButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Register');
  }

  void _onSignUpTherapistButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/RegisterTherapist');
  }
}
