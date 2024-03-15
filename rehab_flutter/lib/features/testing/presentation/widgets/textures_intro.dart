import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_state.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/scrolling_actuators/data/data_sources/anipattern_provider.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';
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
    final Offset animatedPosition = AniPatternProvider().doubleVPattern(imageSize, animationController.value);
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
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: _buildBody(currentImageTexture, desiredSize),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentImageTextureInd < TestingDataProvider.imageTextures.length - 1
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: AppButton(
                          onPressed: () => _onAnimationFinish(),
                          child: const Text('Next Texture'),
                        ),
                      )
                    : const SizedBox(),
                AppButton(
                  onPressed: () => widget.onProceed(TestingState.textures),
                  child: const Text('Proceed'),
                ),
              ],
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
                Text(currentImageTexture.name),
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
