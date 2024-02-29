import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/features/texture_therapy/data/image_texture_provider.dart';
import 'package:rehab_flutter/injection_container.dart';

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
              onPressed: () => sendTherapyPattern("<205205205205205205205205205205>"),
              child: const Text('Rhythmic Therapy'),
            ),
            ElevatedButton(
              onPressed: () => _onPTButtonPressed(context),
              child: const Text('Piano Tiles'),
            ),
            ElevatedButton(
              onPressed: () => _onSTButtonPressed(context),
              child: const Text('Scrolling Textures'),
            ),
            ElevatedButton(
              onPressed: () => _onSAButtonPressed(context),
              child: const Text('Scrolling Actuators'),
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

  void _onSTButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/BgSongSelect');
  }

  void _onSAButtonPressed(BuildContext context) {
    int photoSize = MediaQuery.of(context).size.width.toInt();

    sl<ActuatorsBloc>().add(InitActuatorsEvent(ActuatorsInitData(
      imgSrc: ImageTextureProvider().imageTextures[0].texture,
      orientation: ActuatorsOrientation.landscape,
      numOfFingers: ActuatorsNumOfFingers.five,
      photosHeight: photoSize,
      photosWidth: photoSize,
    )));
    Navigator.pushNamed(context, '/ScrollActuators');
  }

  void _onTestButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Test');
  }

  void _onTextureTButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/TextureTherapy');
  }
}
