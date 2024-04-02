import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_state.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/data_sources/anipattern_provider.dart';
import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';
import 'package:rehab_flutter/injection_container.dart';

import '../../../../core/bloc/actuators/actuators_event.dart';

class STTextures extends StatefulWidget {
  final AppUser user;
  final int intensity;
  final int countdownDuration;
  final Function() submitCallback;

  const STTextures({
    super.key,
    required this.user,
    required this.intensity,
    required this.countdownDuration,
    required this.submitCallback,
  });

  @override
  State<STTextures> createState() => _STTexturesState();
}

class _STTexturesState extends State<STTextures> with TickerProviderStateMixin {
  final Random random = Random();
  late Timer timer;
  late int countdownDuration;
  late int intervalBetweenPatterns;
  late List<ImageTexture> imageTexturesList;
  late AnimationController animationController;
  bool isPlaying = false;
  int currentInd = 0;

  void incrementCurrentInd() {
    setState(() {
      if (currentInd + 1 == imageTexturesList.length) {
        imageTexturesList.shuffle(random);
        currentInd = 0;
      } else {
        currentInd++;
      }
      isPlaying = true;
    });
  }

  void startCountdown() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (countdownDuration < 1) {
          setState(() {
            endCountdown();
          });
          widget.submitCallback();
        } else {
          setState(() {
            countdownDuration -= 1;
          });
        }
      },
    );
  }

  void endCountdown() {
    timer.cancel();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
  }

  void _onAnimationFinish() {
    animationController.reset();
    incrementCurrentInd();
    sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(src: imageTexturesList[currentInd].texture, preload: false)));
    animationController.forward();
  }

  void _renderActuators(double imageSize) {
    final Offset animatedPosition = AniPatternProvider.doubleVPattern(imageSize, animationController.value);
    sl<ActuatorsBloc>().add(UpdateActuatorsEvent(animatedPosition));

    setState(() {});
  }

  @override
  void initState() {
    countdownDuration = widget.countdownDuration;
    intervalBetweenPatterns = ((6 - widget.intensity) * 2) + 10;
    imageTexturesList = List.from(TestingDataProvider.imageTextures);
    imageTexturesList.shuffle(random);
    startCountdown();
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: intervalBetweenPatterns),
    );

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isPlaying = false;
        });

        _onAnimationFinish();
      }
    });
    animationController.addListener(() {
      setState(() {});
    });

    isPlaying = true;
    animationController.forward();
  }

  @override
  void dispose() {
    timer.cancel();
    animationController.dispose();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (isPlaying) {
      _renderActuators(screenWidth);
    }

    return BlocProvider(
      create: (_) => sl<ActuatorsBloc>()
        ..add(InitActuatorsEvent(ActuatorsInitData(
          imgSrc: imageTexturesList[currentInd].texture,
          orientation: ActuatorsOrientation.landscape,
          numOfFingers: ActuatorsNumOfFingers.five,
          imagesHeight: screenWidth.toInt(),
          imagesWidth: screenWidth.toInt(),
        ))),
      child: Column(
        children: [
          const SizedBox(height: 32),
          TestLabel(label: countdownDuration == 0 ? "None" : imageTexturesList[currentInd].name.capitalize!),
          const SizedBox(height: 16),
          Container(
            height: screenWidth,
            width: double.infinity,
            color: Colors.black,
            child: _buildBody(imageTexturesList[currentInd], screenWidth.toInt()),
          ),
          const SizedBox(height: 16),
          Text(
            "Time remaining: ${secToMinSec(countdownDuration.toDouble())}",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ImageTexture currentTexture, int desiredSize) {
    return BlocBuilder<ActuatorsBloc, ActuatorsState>(
      builder: (context, state) {
        if (state is ActuatorsLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is ActuatorsDone) {
          return Center(
            child: Column(
              children: <Widget>[
                const Spacer(),
                Stack(
                  children: [
                    Container(
                      width: desiredSize.toDouble(),
                      height: desiredSize.toDouble(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(currentTexture.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ...sl<ActuatorsController>().buildActuators(),
                  ],
                ),
                const Spacer(),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
