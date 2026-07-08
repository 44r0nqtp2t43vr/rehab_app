import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_state.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/core/data_sources/anipattern_provider.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';

import 'package:rehab_flutter/injection_container.dart';

class TexturesIntro extends StatefulWidget {
  final void Function(TestingState) onProceed;

  const TexturesIntro({super.key, required this.onProceed});

  @override
  State<TexturesIntro> createState() => _TexturesIntroState();
}

class _TexturesIntroState extends State<TexturesIntro> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  ImageTexture currentImageTexture = TestingDataProvider.imageTextures[0];
  int currentImageTextureInd = 0;
  bool isPlaying = false;

  void _onAnimationFinish() {
    animationController.reset();
    if (currentImageTextureInd < TestingDataProvider.imageTextures.length - 1) {
      setState(() {
        currentImageTextureInd++;
        currentImageTexture = TestingDataProvider.imageTextures[currentImageTextureInd];
        isPlaying = true;
      });
      sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(src: currentImageTexture.texture, preload: false)));
      animationController.forward();
    }
  }

  void _renderActuators(double imageSize) {
    final Offset animatedPosition = AniPatternProvider.doubleVPattern(imageSize, animationController.value);
    sl<ActuatorsBloc>().add(UpdateActuatorsEvent(animatedPosition));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int desiredSize = MediaQuery.of(context).size.width.toInt();

    if (isPlaying) {
      _renderActuators(desiredSize.toDouble());
    }

    return BlocProvider(
      create: (_) => sl<ActuatorsBloc>()
        ..add(InitActuatorsEvent(ActuatorsInitData(
          imgSrc: currentImageTexture.texture,
          orientation: ActuatorsOrientation.landscape,
          numOfFingers: ActuatorsNumOfFingers.five,
          imagesHeight: desiredSize,
          imagesWidth: desiredSize,
        ))),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 32),
            TestLabel(label: currentImageTexture.name.capitalize!),
            const SizedBox(height: 16),
            SizedBox(
              height: desiredSize.toDouble(),
              child: _buildBody(currentImageTexture, desiredSize),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentImageTextureInd < TestingDataProvider.imageTextures.length - 1
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: ElevatedButton(
                          onPressed: () => _onAnimationFinish(),
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xff275492),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xff01FF99),
                            ),
                            elevation: WidgetStateProperty.all<double>(0),
                            // shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Next Texture',
                            style: TextStyle(
                              fontFamily: 'Sailec Medium',
                              fontSize: 15,
                              height: 1.2,
                              color: Color(0XFF275492),
                            ),
                          ),
                        ),
                        // AppButton(
                        //   onPressed: () => _onAnimationFinish(),
                        //   child: const Text('Next Texture'),
                        // ),
                      )
                    : const SizedBox(),

                ElevatedButton(
                  // onPressed: () => widget.onProceed(TestingState.textures),
                  onPressed: () {},
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color(0XFF128BED),
                    ),
                    elevation: WidgetStateProperty.all<double>(0),
                    // shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                    overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Proceed',
                        style: darkTextTheme().displaySmall,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        CupertinoIcons.arrow_right,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                // AppButton(
                //   onPressed: () => widget.onProceed(TestingState.textures),
                //   child: const Text('Proceed'),
                // ),
              ],
            ),
          ],
        ),
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
