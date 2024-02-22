import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/routes/routes.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';

import 'package:rehab_flutter/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haplos',
      theme: theme(),
      onGenerateRoute: AppRoutes.onGenerateRoutes,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haplos'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior
            .opaque, // Ensures the GestureDetector is as large as its parent
        onTap: () =>
            // _onATButtonPressed(context),
            _onBlueToothScreenTap(context),

        child: Center(
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

void _onTest(BuildContext context) {
  Navigator.pushNamed(context, '/ActuatorTherapy');
}
