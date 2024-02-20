import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';

class TextureNameSelector extends StatelessWidget {
  final PageController controller;
  final List<ImageTexture> imageTextures;
  final Function(int) onPageChanged;

  const TextureNameSelector({
    Key? key,
    required this.controller,
    required this.imageTextures,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Adjust the height as needed
      color: Colors.lightBlueAccent, // Add your color here
      child: PageView.builder(
        controller: controller,
        itemCount: imageTextures.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              imageTextures[index].name,
              style: TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
