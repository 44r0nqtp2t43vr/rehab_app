import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/injection_container.dart';
import 'package:rehab_flutter/screens/texture_therapy_screen.dart';

class MenuScreen extends StatelessWidget {
  final BluetoothController bluetoothController = BluetoothController();

  MenuScreen({
    Key? key,
  }) : super(key: key);

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
            ElevatedButton(
              onPressed: () => _onATButtonPressed(context),
              child: const Text('Actuator Therapy'),
            ),
            ElevatedButton(
              onPressed: () => _onPatternTButtonPressed(context),
              child: const Text('Pattern Therapy'),
            ),
            ElevatedButton(
              onPressed: () => _onTextureTButtonPressed(context),
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
            ElevatedButton(
              onPressed: () => _onTestButtonPressed(context),
              child: const Text('Test'),
            ),
          ],
        ),
      ),
    );
  }

  void _onPTButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/SongSelect');
  }

  void _onATButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/ActuatorTherapy');
  }

  void _onPatternTButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PatternTherapy');
  }

  void _onTestButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Test');
  }

  void _onTextureTButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/TextureTherapy');
  }
}
