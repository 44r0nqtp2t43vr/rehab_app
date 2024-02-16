import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rehab_flutter/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/screens/actuator_therapy_screen.dart';

class MenuScreen extends StatelessWidget {
  final BluetoothCharacteristic targetCharacteristic;
  final BluetoothController bluetoothController = BluetoothController();

  MenuScreen({Key? key, required this.targetCharacteristic}) : super(key: key);

  void sendTherapyPattern(String pattern) {
    bluetoothController.sendPattern(targetCharacteristic, pattern);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Text(
                    'Characteristic Selected: ${targetCharacteristic.uuid}')),
            ElevatedButton(
              onPressed: () =>
                  // go to actuactor therapy screen
                  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ActuatorTherapy(
                      targetCharacteristic: targetCharacteristic),
                ),
              ),
              child: Text('Actuator Therapy'),
            ),
            ElevatedButton(
              onPressed: () =>
                  sendTherapyPattern("<205205205205205205205205205205>"),
              child: Text('Pattern Therapy'),
            ),
            ElevatedButton(
              onPressed: () =>
                  sendTherapyPattern("<088088088088088088088088088088>"),
              child: Text('Texture Therapy'),
            ),
            ElevatedButton(
              onPressed: () =>
                  sendTherapyPattern("<205205205205205205205205205205>"),
              child: Text('Rhythmic Therapy'),
            ),
            ElevatedButton(
              onPressed: () =>
                  sendTherapyPattern("<088088088088088088088088088088>"),
              child: Text('Piano Tiles'),
            ),
          ],
        ),
      ),
    );
  }
}
