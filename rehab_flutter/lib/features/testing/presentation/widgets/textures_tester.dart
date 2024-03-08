import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';
import 'package:rehab_flutter/features/texture_therapy/data/image_texture_provider.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';
import 'package:rehab_flutter/injection_container.dart';

class TexturesTester extends StatefulWidget {
  final void Function(double) onResponse;

  const TexturesTester({super.key, required this.onResponse});

  @override
  State<TexturesTester> createState() => _TexturesTesterState();
}

class _TexturesTesterState extends State<TexturesTester> {
  ImageTexture currentImageTexture = ImageTextureProvider().imageTextures[0];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActuatorsBloc>()
        ..add(InitActuatorsEvent(ActuatorsInitData(
          imgSrc: currentImageTexture.texture,
          orientation: ActuatorsOrientation.landscape,
          numOfFingers: ActuatorsNumOfFingers.five,
          imagesHeight: 0,
          imagesWidth: 0,
        ))),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: Textures.values.map((texture) {
                return ElevatedButton(
                  onPressed: () {
                    // Handle button press here
                  },
                  child: Text(texture.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
