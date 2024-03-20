import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_state.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/core/data_sources/image_texture_provider.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_frame/texture_frame.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_name_selector.dart';
import 'package:rehab_flutter/injection_container.dart';

class TextureTherapy extends StatefulWidget {
  const TextureTherapy({Key? key}) : super(key: key);

  @override
  State<TextureTherapy> createState() => _TextureTherapyState();
}

class _TextureTherapyState extends State<TextureTherapy> {
  ImageTextureProvider imageTextureProvider = ImageTextureProvider();
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageTexture currentTexture = imageTextureProvider.imageTextures[currentIndex];

    return BlocProvider(
      create: (_) => sl<ActuatorsBloc>()
        ..add(InitActuatorsEvent(ActuatorsInitData(
          imgSrc: imageTextureProvider.imageTextures[0].texture,
          orientation: ActuatorsOrientation.landscape,
          numOfFingers: ActuatorsNumOfFingers.one,
          imagesHeight: 0,
          imagesWidth: 0,
        ))),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Texture Therapy'),
        ),
        body: _buildBody(currentTexture),
      ),
    );
  }

  Widget _buildBody(ImageTexture currentTexture) {
    return BlocBuilder<ActuatorsBloc, ActuatorsState>(
      builder: (context, state) {
        if (state is ActuatorsLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is ActuatorsDone) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextureFrame(imageTexture: currentTexture),
                // put TextureNameSelector on the bottom
                const SizedBox(height: 100),
                TextureNameSelector(
                  controller: _pageController,
                  imageTextures: imageTextureProvider.imageTextures,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                    sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(src: imageTextureProvider.imageTextures[index].texture, preload: false)));
                  },
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
