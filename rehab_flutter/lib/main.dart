import 'package:flutter/material.dart';
import 'screens/bluetooth_screen.dart'; // Make sure this import path matches your file structure

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haplos',
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BluetoothScreen()),
          );
        },
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
