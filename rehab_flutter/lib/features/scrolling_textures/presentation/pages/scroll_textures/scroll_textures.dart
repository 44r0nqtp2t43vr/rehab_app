import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_state.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/core/widgets/animation_button.dart';
import 'package:rehab_flutter/features/scrolling_textures/domain/enums/animation_state.dart';
import 'package:rehab_flutter/features/scrolling_textures/presentation/widgets/gallery.dart';
import 'package:rehab_flutter/core/data_sources/image_texture_provider.dart';
import 'package:rehab_flutter/injection_container.dart';

class ScrollTextures extends StatefulWidget {
  const ScrollTextures({super.key});

  @override
  State<ScrollTextures> createState() => _ScrollTexturesState();
}

class _ScrollTexturesState extends State<ScrollTextures>
    with TickerProviderStateMixin {
  late List<ImageTexture> imageTextures;
  late AnimationController animationController;
  late AnimationController animationControllerHoriz;
  int currentImgIndex = 0;
  int rotateFactor = 0;
  bool hasStarted = true;
  bool isPlaying = true;
  bool isEnded = false;
  bool isLastVertStateDownward = true;
  AnimationState animationState = AnimationState.downward;

  void _pauseAnimation() {
    if (sl<ActuatorsController>().orientation ==
        ActuatorsOrientation.landscape) {
      animationController.stop();
    } else {
      animationControllerHoriz.stop();
    }
    setState(() {
      isPlaying = false;
    });
  }

  void _resumeAnimation() {
    if (animationState == AnimationState.downward) {
      animationController.forward();
    } else if (animationState == AnimationState.upward) {
      animationController.reverse();
    } else if (animationState == AnimationState.sideward) {
      if (animationControllerHoriz.status == AnimationStatus.forward) {
        animationControllerHoriz.forward();
      } else {
        animationControllerHoriz.reverse();
      }
    }
    setState(() {
      isPlaying = true;
    });
  }

  void _setDirectionVert() {
    animationControllerHoriz.stop();
    if (isLastVertStateDownward) {
      animationController
          .removeStatusListener(_downwardAnimationStatusListener);
      animationController.addStatusListener(_upwardAnimationStatusListener);
    } else {
      animationController.removeStatusListener(_upwardAnimationStatusListener);
      animationController.addStatusListener(_downwardAnimationStatusListener);
    }
    setState(() {
      sl<ActuatorsController>().orientation = ActuatorsOrientation.landscape;
      if (isLastVertStateDownward) {
        animationState = AnimationState.upward;
        isLastVertStateDownward = false;
        currentImgIndex = currentImgIndex + 2;
        isEnded = false;
      } else {
        animationState = AnimationState.downward;
        isLastVertStateDownward = true;
        currentImgIndex = currentImgIndex - 2;
        isEnded = false;
      }
    });

    int indexToLoad = getIndexToLoad(preload: true);
    if (!(indexToLoad < 0 || indexToLoad > imageTextures.length - 1)) {
      sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(
          src: imageTextures[getIndexToLoad(preload: true)].texture,
          preload: true,
          resetActuators: false,
          rotateFactor: rotateFactor)));
    }
    _resumeAnimation();
  }

  void _switchDirectionVert() {
    _pauseAnimation();

    if (animationState == AnimationState.downward) {
      setState(() {
        animationState = AnimationState.upward;
        currentImgIndex = currentImgIndex + 2;
        isEnded = false;
        isLastVertStateDownward = false;
      });
      animationController
          .removeStatusListener(_downwardAnimationStatusListener);
      animationController.addStatusListener(_upwardAnimationStatusListener);
    } else if (animationState == AnimationState.upward) {
      setState(() {
        animationState = AnimationState.downward;
        currentImgIndex = currentImgIndex - 2;
        isEnded = false;
        isLastVertStateDownward = true;
      });
      animationController.removeStatusListener(_upwardAnimationStatusListener);
      animationController.addStatusListener(_downwardAnimationStatusListener);
    } else if (animationState == AnimationState.sideward) {
      animationControllerHoriz.stop();
      setState(() {
        animationState = isLastVertStateDownward
            ? AnimationState.downward
            : AnimationState.upward;
        isLastVertStateDownward = isLastVertStateDownward ? true : false;
        sl<ActuatorsController>().orientation = ActuatorsOrientation.landscape;
      });
    }

    int indexToLoad = getIndexToLoad(preload: true);
    if (!(indexToLoad < 0 || indexToLoad > imageTextures.length - 1)) {
      sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(
          src: imageTextures[getIndexToLoad(preload: true)].texture,
          preload: true,
          resetActuators: false,
          rotateFactor: rotateFactor)));
    }
    _resumeAnimation();
  }

  void _switchDirectionHoriz() {
    setState(() {
      if (sl<ActuatorsController>().orientation ==
          ActuatorsOrientation.landscape) {
        sl<ActuatorsController>().orientation = ActuatorsOrientation.portrait;
      }

      animationState = AnimationState.sideward;
      animationControllerHoriz.value = 0.0;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.stop();
      animationControllerHoriz.forward(from: 0);
    });
  }

  void _incrementRotateFactor() {
    setState(() {
      rotateFactor = rotateFactor < 3 ? rotateFactor + 1 : 0;
    });

    sl<ActuatorsController>().rotateImages();
  }

  void _downwardAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed && isPlaying) {
      if (currentImgIndex == imageTextures.length - 3) {
        setState(() {
          isEnded = true;
        });
      } else {
        setState(() {
          currentImgIndex++;
          sl<ActuatorsController>().imagesToScan[0] =
              sl<ActuatorsController>().imagesToScan[1];
          sl<ActuatorsController>().imagesToScan[1] =
              img.Image(height: 0, width: 0);
        });
        // _loadImage(preload: true);
        int indexToLoad = getIndexToLoad(preload: true);
        if (!(indexToLoad < 0 || indexToLoad > imageTextures.length - 1)) {
          sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(
              src: imageTextures[getIndexToLoad(preload: true)].texture,
              preload: true,
              resetActuators: false,
              rotateFactor: rotateFactor)));
        }
        animationController.forward(from: 0);
      }
    }
  }

  void _upwardAnimationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && isPlaying) {
      if (currentImgIndex == 2) {
        setState(() {
          isEnded = true;
        });
      } else {
        setState(() {
          currentImgIndex--;
          if (currentImgIndex - 1 > 0) {
            sl<ActuatorsController>().imagesToScan[2] =
                sl<ActuatorsController>().imagesToScan[0];
            sl<ActuatorsController>().imagesToScan[0] =
                sl<ActuatorsController>().imagesToScan[1];
          }
        });

        int indexToLoad = getIndexToLoad(preload: true);
        if (!(indexToLoad < 0 || indexToLoad > imageTextures.length - 1)) {
          sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(
              src: imageTextures[getIndexToLoad(preload: true)].texture,
              preload: true,
              resetActuators: false,
              rotateFactor: rotateFactor)));
        }

        animationController.reverse(from: 1);
      }
    }
  }

  int getIndexToLoad({required bool preload}) {
    return preload
        ? animationState == AnimationState.downward
            ? currentImgIndex + 1
            : currentImgIndex - 3
        : animationState == AnimationState.downward
            ? currentImgIndex
            : currentImgIndex - 2;
  }

  void _restart() {
    animationControllerHoriz.stop();
    setState(() {
      if (isLastVertStateDownward) {
        currentImgIndex = 0;
      } else {
        currentImgIndex = ImageTextureProvider().imageTextures.length + 1;
      }
      imageTextures = List.from([
        ...ImageTextureProvider().imageTextures,
        ...[
          ImageTexture(name: "", image: "", texture: ""),
          ImageTexture(name: "", image: "", texture: "")
        ]
      ]);
      hasStarted = true;
      isPlaying = true;
      isEnded = false;
      sl<ActuatorsController>().resetActuators();
      sl<ActuatorsController>().imagesToScan = [
        img.Image(height: 0, width: 0),
        img.Image(height: 0, width: 0),
        img.Image(height: 0, width: 0)
      ];
      animationState = isLastVertStateDownward
          ? AnimationState.downward
          : AnimationState.upward;
      isLastVertStateDownward = isLastVertStateDownward ? true : false;
      sl<ActuatorsController>().orientation = ActuatorsOrientation.landscape;
    });
    animationController.reset();

    int indexToLoad = getIndexToLoad(preload: false);
    if (!(indexToLoad < 0 || indexToLoad > imageTextures.length - 1)) {
      sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(
          src: imageTextures[getIndexToLoad(preload: false)].texture,
          preload: false,
          resetActuators: false,
          rotateFactor: rotateFactor)));
    }
    indexToLoad = getIndexToLoad(preload: true);
    if (!(indexToLoad < 0 || indexToLoad > imageTextures.length - 1)) {
      sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(
          src: imageTextures[getIndexToLoad(preload: true)].texture,
          preload: true,
          resetActuators: false,
          rotateFactor: rotateFactor)));
    }

    if (animationState != AnimationState.upward) {
      animationController.forward();
    } else if (animationState != AnimationState.downward) {
      animationController.reverse(from: 1);
    }
  }

  void _onPass(BuildContext context) {
    sl<ActuatorsController>().updateActuatorsScrollingAnimation(
        animationValue: animationController.value,
        animationHorizValue: animationControllerHoriz.value,
        isLastVertStateDownward: isLastVertStateDownward);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    imageTextures = List.from([
      ...ImageTextureProvider().imageTextures,
      ...[
        ImageTexture(name: "", image: "", texture: ""),
        ImageTexture(name: "", image: "", texture: "")
      ]
    ]);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    animationControllerHoriz = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    if (animationState == AnimationState.downward) {
      animationController.addStatusListener(_downwardAnimationStatusListener);
    } else if (animationState == AnimationState.upward) {
      currentImgIndex = ImageTextureProvider().imageTextures.length + 1;
      animationController.addStatusListener(_upwardAnimationStatusListener);
    }

    animationControllerHoriz.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationControllerHoriz.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationControllerHoriz.forward();
      }
    });

    int indexToLoad = getIndexToLoad(preload: false);
    if (!(indexToLoad < 0 || indexToLoad > imageTextures.length - 1)) {
      sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(
          src: imageTextures[getIndexToLoad(preload: false)].texture,
          preload: false,
          resetActuators: false,
          rotateFactor: rotateFactor)));
    }
    indexToLoad = getIndexToLoad(preload: true);
    if (!(indexToLoad < 0 || indexToLoad > imageTextures.length - 1)) {
      sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(
          src: imageTextures[getIndexToLoad(preload: true)].texture,
          preload: true,
          resetActuators: false,
          rotateFactor: rotateFactor)));
    }

    animationController.addListener(() {
      _onPass(context);
    });

    animationControllerHoriz.addListener(() {
      _onPass(context);
    });

    if (animationState == AnimationState.downward) {
      animationController.forward();
    } else if (animationState == AnimationState.upward) {
      animationController.reverse(from: 1);
    }
  }

  @override
  void dispose() {
    sl<BluetoothBloc>()
        .add(const WriteDataEvent("<000000000000000000000000000000>"));
    animationController.dispose();
    animationControllerHoriz.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imgHeight = MediaQuery.of(context).size.height / 2;
    double imgWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => sl<ActuatorsBloc>()
        ..add(InitActuatorsEvent(ActuatorsInitData(
          imgSrc: imageTextures[0].texture,
          orientation: ActuatorsOrientation.landscape,
          numOfFingers: ActuatorsNumOfFingers.five,
          imagesHeight: imgHeight.toInt(),
          imagesWidth: imgWidth.toInt(),
        ))),
      child: Scaffold(
        body: _buildBody(imgHeight, imgWidth),
      ),
    );
  }

  Widget _buildBody(double imgHeight, double imgWidth) {
    return BlocBuilder<ActuatorsBloc, ActuatorsState>(
      builder: (context, state) {
        if (state is ActuatorsLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is ActuatorsDone) {
          return Material(
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _drawGallery(imgHeight, imgWidth),
                  ],
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff128BED),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8, right: 16, bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              size: 35,
                              color: Colors.white,
                            ),
                            onPressed: () => _onBackButtonPressed(context),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cutaneous',
                                style: darkTextTheme().headlineLarge,
                              ),
                              Text(
                                "Scrolling Textures",
                                style: darkTextTheme().headlineSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // AppIconButtonText(
                  //   icon: const Icon(Icons.chevron_left),
                  //   text: const Text("Back"),
                  //   onPressed: () => _onBackButtonPressed(context),
                  // ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Column(
                    children: [
                      AnimationButton(
                        onPressed: () => isEnded
                            ? _restart()
                            : isPlaying
                                ? _pauseAnimation()
                                : _resumeAnimation(),
                        icon: Icon(isEnded
                            ? Icons.restart_alt
                            : isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AnimationButton(
                        onPressed: () =>
                            animationState == AnimationState.sideward && isEnded
                                ? _setDirectionVert()
                                : _switchDirectionVert(),
                        icon: const Icon(Icons.swap_vert),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AnimationButton(
                        onPressed: () => _switchDirectionHoriz(),
                        icon: const Icon(Icons.swap_horiz),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AnimationButton(
                        onPressed: () => _incrementRotateFactor(),
                        icon: const Icon(Icons.rotate_90_degrees_cw),
                      ),
                    ],
                  ),
                ),
                ...sl<ActuatorsController>().buildActuators(),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _drawGallery(double imgHeight, double imgWidth) {
    List<ImageTexture> currentImageTextures = [];
    if (animationState == AnimationState.downward) {
      currentImageTextures =
          imageTextures.sublist(currentImgIndex, currentImgIndex + 3);
    } else if (animationState == AnimationState.upward) {
      currentImageTextures =
          imageTextures.sublist(currentImgIndex - 2, currentImgIndex + 1);
    } else if (animationState == AnimationState.sideward) {
      if (isLastVertStateDownward) {
        currentImageTextures =
            imageTextures.sublist(currentImgIndex, currentImgIndex + 3);
      } else {
        currentImageTextures =
            imageTextures.sublist(currentImgIndex - 2, currentImgIndex + 1);
      }
    }

    return Expanded(
      child: Gallery(
        imgHeight: imgHeight,
        imgWidth: imgWidth,
        imageTextures: currentImageTextures,
        currentImgIndex: currentImgIndex,
        rotateFactor: rotateFactor,
        isActuatorsHorizontal: sl<ActuatorsController>().orientation ==
            ActuatorsOrientation.landscape,
        animation: animationController,
        key: GlobalKey(),
      ),
    );
  }

  void _onBackButtonPressed(BuildContext context) {
    Navigator.of(context).pushReplacementNamed("/TextureTherapy");
  }
}
