import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';

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
      height: 50,
      color: const Color(0xff128BED),
      child: PageView.builder(
        controller: controller,
        itemCount: imageTextures.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              imageTextures[index].name,
              style: darkTextTheme().headlineMedium,
            ),
          );
        },
      ),
    );
  }
}
