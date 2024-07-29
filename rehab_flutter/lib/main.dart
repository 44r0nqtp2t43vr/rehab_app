import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/admin_patient_numbers/admin_patient_numbers_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_therapist/viewed_therapist_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/patients_numbers/patients_numbers_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/test_analytics/test_analytics_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patient_list_sessions/therapist_patient_list_sessions_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patient_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan/viewed_therapist_patient_plan_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plans_list/viewed_therapist_patient_plans_list_bloc.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/bloc/patient_plans/patient_plans_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_plan/patient_current_plan_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'firebase_options.dart';
import 'package:rehab_flutter/injection_container.dart';
import 'package:rehab_flutter/config/routes/routes.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/features/login_register/presentation/pages/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (BuildContext context) => sl()),
        BlocProvider<TherapistBloc>(create: (BuildContext context) => sl()),
        BlocProvider<AdminBloc>(create: (BuildContext context) => sl()),
        BlocProvider<TherapistListBloc>(create: (BuildContext context) => sl()),
        BlocProvider<PatientListBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ViewedTherapistBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ViewedPatientBloc>(create: (BuildContext context) => sl()),
        BlocProvider<TherapistPatientListBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ViewedTherapistPatientBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ViewedTherapistPatientPlanBloc>(create: (BuildContext context) => sl()),
        BlocProvider<PatientPlansBloc>(create: (BuildContext context) => sl()),
        BlocProvider<PatientCurrentPlanBloc>(create: (BuildContext context) => sl()),
        BlocProvider<PatientCurrentSessionBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ViewedTherapistPatientPlansListBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ViewedTherapistPatientPlanSessionsListBloc>(create: (BuildContext context) => sl()),
        BlocProvider<TestAnalyticsBloc>(create: (BuildContext context) => sl()),
        BlocProvider<PatientNumbersBloc>(create: (BuildContext context) => sl()),
        BlocProvider<TherapistPatientListSessionsBloc>(create: (BuildContext context) => sl()),
        BlocProvider<AdminPatientNumbersBloc>(create: (BuildContext context) => sl()),
      ],
      child: MaterialApp(
        title: 'Haplos',
        theme: theme(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        home: const OnboardingScreen(),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haplos'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures the GestureDetector is as large as its parent

        onTap: () => _onBlueToothScreenTap(context),

        child: const Center(
          child: Text(
            'Welcome to Haplos!\nTap the screen to set up your gloves.',
            textAlign: TextAlign.center, // Center-align the text
          ),
        ),
      ),
    );
  }
}

void _onBlueToothScreenTap(BuildContext context) {
  Navigator.pushNamed(context, '/BluetoothScreen');
}
