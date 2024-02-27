import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/animation_button.dart';
import 'package:rehab_flutter/features/scrolling_actuators/domain/enums/animation_direction.dart';
import 'package:rehab_flutter/features/scrolling_actuators/presentation/widgets/animation_slider.dart';
import 'package:rehab_flutter/features/scrolling_actuators/presentation/widgets/scroll_texture_frame.dart';
import 'package:rehab_flutter/features/texture_therapy/data/image_texture_provider.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_name_selector.dart';

class ScrollActuators extends StatefulWidget {
  const ScrollActuators({Key? key}) : super(key: key);

  @override
  State<ScrollActuators> createState() => _ScrollActuatorsState();
}

class _ScrollActuatorsState extends State<ScrollActuators> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final ImageTextureProvider imageTextureProvider = ImageTextureProvider();
  late AnimationController animationController;
  AnimationDirection animationDirection = AnimationDirection.vertical;
  int animationDuration = 4;
  int animationValue = 0;
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
      animationDirection = animationDirection == AnimationDirection.vertical ? AnimationDirection.horizontal : AnimationDirection.vertical;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageTexture currentTexture = imageTextureProvider.imageTextures[currentIndex];

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Spacer(flex: 2),
            ScrollTextureFrame(
              isPlaying: isPlaying,
              imageTexture: currentTexture,
              animationController: animationController,
              animationDirection: animationDirection,
            ),
            const Spacer(flex: 3),
            TextureNameSelector(
              controller: _pageController,
              imageTextures: imageTextureProvider.imageTextures,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
            const Spacer(flex: 1),
            AnimationSlider(
                animationDuration: animationDuration,
                onDurationChanged: (value) {
                  setState(() {
                    animationDuration = value.toInt();
                    animationController.stop();
                    animationController.duration = Duration(seconds: animationDuration);
                    animationController.forward();
                  });
                }),
            const Spacer(flex: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimationButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () => isPlaying ? _pauseAnimation() : _resumeAnimation(),
                ),
                AnimationButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () => _stopAnimation(),
                ),
                AnimationButton(
                  icon: const Icon(Icons.swap_calls),
                  onPressed: () => _toggleAniDirection(),
                ),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
