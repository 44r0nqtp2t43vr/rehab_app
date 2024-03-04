// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/routes/routes.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/features/login_register/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:rehab_flutter/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haplos',
      theme: theme(),
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      home: const OnboardingScreen(),
    );
  }
}
