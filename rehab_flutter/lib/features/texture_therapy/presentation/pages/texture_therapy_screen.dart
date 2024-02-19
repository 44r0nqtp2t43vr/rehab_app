import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Import gesture detector
import 'package:rehab_flutter/features/texture_therapy/data/image_texture_provider.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';

class TextureTherapy extends StatefulWidget {
  const TextureTherapy({Key? key}) : super(key: key);

  @override
  State<TextureTherapy> createState() => _TextureTherapyState();
}

class _TextureTherapyState extends State<TextureTherapy> {
  ImageTextureProvider imageTextureProvider = ImageTextureProvider();
  int currentIndex = 0; // To keep track of the current texture being displayed

  void _nextTexture() {
    setState(() {
      currentIndex =
          (currentIndex + 1) % imageTextureProvider.imageTextures.length;
    });
  }

  void _previousTexture() {
    setState(() {
      currentIndex =
          (currentIndex - 1 + imageTextureProvider.imageTextures.length) %
              imageTextureProvider.imageTextures.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageTexture currentTexture =
        imageTextureProvider.imageTextures[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Texture Therapy'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onHorizontalDragEnd: (DragEndDetails details) {
                if (details.primaryVelocity! > 0) {
                  // User swiped Left
                  _previousTexture();
                } else if (details.primaryVelocity! < 0) {
                  // User swiped Right
                  _nextTexture();
                }
              },
              child: Image.asset(currentTexture.image, width: 400, height: 400),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(currentTexture.name, style: TextStyle(fontSize: 20)),
            ),
            // Removed ElevatedButton since we're using swipes now
          ],
        ),
      ),
    );
  }
}
