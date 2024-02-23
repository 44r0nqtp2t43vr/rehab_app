import 'package:flutter/material.dart';
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
  int animationValue = 0;
  int currentIndex = 0;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
    animationController.addListener(() {
      setState(() {});
    });

    animationController.forward(from: 0);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Set border color here
                  width: 2.0, // Set border width here
                ),
              ),
              child: ScrollTextureFrame(
                imageTexture: currentTexture,
                animationController: animationController,
              ),
            ),

            // put TextureNameSelector on the bottom
            const SizedBox(height: 100),
            TextureNameSelector(
              controller: _pageController,
              imageTextures: imageTextureProvider.imageTextures,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
