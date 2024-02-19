import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/injection_container.dart';
import 'package:rehab_flutter/screens/actuator_therapy_screen.dart';
import 'package:rehab_flutter/screens/pattern_therapy_screen.dart';
import 'package:rehab_flutter/screens/texture_therapy_screen.dart';

class MenuScreen extends StatelessWidget {
  final BluetoothCharacteristic targetCharacteristic;
  final BluetoothController bluetoothController = BluetoothController();

  MenuScreen({Key? key, required this.targetCharacteristic}) : super(key: key);

  void sendTherapyPattern(String pattern) {
    // bluetoothController.sendPattern(targetCharacteristic, pattern);
    sl<BluetoothBloc>().add(WriteDataEvent(pattern));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
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
              child: const Text('Actuator Therapy'),
            ),
            ElevatedButton(
              onPressed: () =>
                  // go to actuactor therapy screen
                  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatternTherapyScreen(
                      targetCharacteristic: targetCharacteristic),
                ),
              ),
              child: const Text('Pattern Therapy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TextureTherapyScreen(
                      targetCharacteristic: targetCharacteristic),
                ),
              ),
              child: const Text('Texture Therapy'),
            ),
            ElevatedButton(
              onPressed: () =>
                  sendTherapyPattern("<205205205205205205205205205205>"),
              child: const Text('Rhythmic Therapy'),
            ),
            ElevatedButton(
              onPressed: () => _onPTButtonPressed(context),
              child: const Text('Piano Tiles'),
            ),
          ],
        ),
      ),
    );
  }

  void _onPTButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/SongSelect');
  }
}
