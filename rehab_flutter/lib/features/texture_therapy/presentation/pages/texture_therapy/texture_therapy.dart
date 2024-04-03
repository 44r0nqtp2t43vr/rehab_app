import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_state.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/enums/animation_direction.dart';
import 'package:rehab_flutter/core/data_sources/image_texture_provider.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/animation_slider.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/scroll_texture_frame.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_name_selector.dart';
import 'package:rehab_flutter/injection_container.dart';

class TextureTherapy extends StatefulWidget {
  const TextureTherapy({Key? key}) : super(key: key);

  @override
  State<TextureTherapy> createState() => _TextureTherapyState();
}

class _TextureTherapyState extends State<TextureTherapy>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final ImageTextureProvider imageTextureProvider = ImageTextureProvider();
  late AnimationController animationController;
  AnimationDirection animationDirection = AnimationDirection.vertical;
  int animationDuration = 4;
  int currentIndex = 0;
  bool isPlaying = false;
  bool isEnded = false;

  void _pauseAnimation() {
    animationController.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void _resumeAnimation() {
    if (isEnded) {
      animationController.reset();
    }
    animationController.forward();
    setState(() {
      if (isEnded) {
        isEnded = false;
      }
      isPlaying = true;
    });
  }

  void _stopAnimation() {
    animationController.reset();
    setState(() {
      isPlaying = false;
      isEnded = true;
    });
  }

  void _toggleAniDirection() {
    setState(() {
      animationDirection = animationDirection == AnimationDirection.vertical
          ? AnimationDirection.horizontal
          : AnimationDirection.vertical;
    });
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: animationDuration),
    );

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isEnded = true;
          isPlaying = false;
        });
      }
    });
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    animationController.dispose();
    sl<BluetoothBloc>()
        .add(const WriteDataEvent("<000000000000000000000000000000>"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageTexture currentTexture =
        imageTextureProvider.imageTextures[currentIndex];
    int desiredSize = MediaQuery.of(context).size.width.toInt();

    return BlocProvider(
      create: (_) => sl<ActuatorsBloc>()
        ..add(InitActuatorsEvent(ActuatorsInitData(
          imgSrc: imageTextureProvider.imageTextures[0].texture,
          orientation: ActuatorsOrientation.landscape,
          numOfFingers: ActuatorsNumOfFingers.five,
          imagesHeight: desiredSize,
          imagesWidth: desiredSize,
        ))),
      child: Scaffold(
        body: _buildBody(currentTexture, desiredSize),
      ),
    );
  }

  Widget _buildBody(ImageTexture currentTexture, int desiredSize) {
    return BlocBuilder<ActuatorsBloc, ActuatorsState>(
      builder: (context, state) {
        if (state is ActuatorsLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is ActuatorsDone) {
          return SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 24, bottom: 12, right: 24),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            size: 35,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cutaneous',
                                style: darkTextTheme().headlineLarge,
                              ),
                              Text(
                                "Texture Therapy",
                                style: darkTextTheme().headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  ScrollTextureFrame(
                    imgSize: desiredSize,
                    isPlaying: isPlaying,
                    imageTexture: currentTexture,
                    animationController: animationController,
                    animationDirection: animationDirection,
                  ),
                  const Spacer(flex: 1),
                  TextureNameSelector(
                    controller: _pageController,
                    imageTextures: imageTextureProvider.imageTextures,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                      sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(
                          src:
                              imageTextureProvider.imageTextures[index].texture,
                          preload: false)));
                    },
                  ),
                  const Spacer(flex: 1),
                  AnimationSlider(
                    animationDuration: animationDuration,
                    onDurationChanged: (value) {
                      setState(() {
                        animationDuration = value.toInt();
                        animationController.stop();
                        animationController.duration =
                            Duration(seconds: animationDuration);
                        animationController.forward();
                      });
                    },
                  ),
                  const Spacer(flex: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                          isPlaying
                              ? CupertinoIcons.pause_circle_fill
                              : CupertinoIcons.play_circle_fill,
                          size: 40,
                          color: isPlaying
                              ? const Color(0xff01FF99)
                              : Colors.white,
                        ),
                        onPressed: () =>
                            isPlaying ? _pauseAnimation() : _resumeAnimation(),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(
                          CupertinoIcons.stop_circle_fill,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () => _stopAnimation(),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(
                          CupertinoIcons.arrow_swap,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () => _toggleAniDirection(),
                      ),
                      TextButton.icon(
                        onPressed: () => _onSTButtonPressed(context),
                        label: const Text('Scroll'),
                        icon: const Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF128BED),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontFamily: 'Sailec Medium',
                              fontSize: 16,
                            ),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      // AnimationButton(
                      //   icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      //   onPressed: () =>
                      //       isPlaying ? _pauseAnimation() : _resumeAnimation(),
                      // ),
                      // AnimationButton(
                      //   icon: const Icon(Icons.stop),
                      //   onPressed: () => _stopAnimation(),
                      // ),
                      // AnimationButton(
                      //   icon: const Icon(Icons.swap_calls),
                      //   onPressed: () => _toggleAniDirection(),
                      // ),
                      // AppIconButtonText(
                      //   icon: const Icon(Icons.chevron_right),
                      //   text: const Text("Scroll Textures"),
                      //   onPressed: () => _onSTButtonPressed(context),
                      // ),
                    ],
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  void _onSTButtonPressed(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/ScrollTextures");
  }
}
