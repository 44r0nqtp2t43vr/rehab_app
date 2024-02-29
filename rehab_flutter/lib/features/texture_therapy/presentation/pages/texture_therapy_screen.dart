import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/texture_therapy/data/image_texture_provider.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_frame/texture_frame.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/widgets/texture_name_selector.dart';

class TextureTherapy extends StatefulWidget {
  const TextureTherapy({Key? key}) : super(key: key);

  @override
  State<TextureTherapy> createState() => _TextureTherapyState();
}

class _TextureTherapyState extends State<TextureTherapy> {
  ImageTextureProvider imageTextureProvider = ImageTextureProvider();
  final PageController _pageController = PageController();
  int currentIndex = 0; // To keep track of the current texture being displayed

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageTexture currentTexture = imageTextureProvider.imageTextures[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Texture Therapy'),
      ),
      body: Center(
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
