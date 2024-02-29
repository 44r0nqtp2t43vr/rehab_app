// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/routes/routes.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/features/piano_tiles/data/data_sources/song_provider.dart';
import 'package:rehab_flutter/features/texture_therapy/data/image_texture_provider.dart';
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
      home: const WelcomeScreen(),
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
        onTap: () =>
            // _onATButtonPressed(context),
            // _onBlueToothScreenTap(context),
            _onTest(context),

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

void _onTest(BuildContext context) {
  int photoSize = MediaQuery.of(context).size.width.toInt();

  sl<ActuatorsBloc>().add(InitActuatorsEvent(ActuatorsInitData(
    imgSrc: ImageTextureProvider().imageTextures[0].texture,
    orientation: ActuatorsOrientation.landscape,
    numOfFingers: ActuatorsNumOfFingers.five,
    photosHeight: photoSize,
    photosWidth: photoSize,
  )));
  Navigator.pushNamed(context, '/ScrollActuators');
  // Navigator.pushNamed(context, '/ScrollTextures', arguments: SongProvider().songs[0]);
  // Navigator.pushNamed(context, '/TextureTherapy');
}
