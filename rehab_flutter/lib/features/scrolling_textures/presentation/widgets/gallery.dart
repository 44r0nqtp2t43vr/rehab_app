import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/scrolling_textures/presentation/widgets/img_tile.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';

class Gallery extends AnimatedWidget {
  final double imgHeight;
  final double imgWidth;
  final int currentImgIndex;
  final int rotateFactor;
  final bool isActuatorsHorizontal;
  final List<ImageTexture> imageTextures;

  const Gallery({required Key key, required this.imgHeight, required this.imgWidth, required this.currentImgIndex, required this.rotateFactor, required this.isActuatorsHorizontal, required this.imageTextures, required Animation<double> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double>? animation = super.listenable as Animation<double>?;

    // map imageTextures to widgets
    List<Widget> tiles = imageTextures.map((imgTexture) {
      //specify distance from top
      int index = imageTextures.indexOf(imgTexture);
      double offset = (1 - index + animation!.value) * imgHeight;

      return Transform.translate(
        offset: Offset(0, offset),
        child: ImgTile(
          height: imgHeight,
          width: imgWidth,
          imgTexture: imgTexture,
          rotateFactor: rotateFactor,
          key: GlobalKey(),
        ),
      );
    }).toList();

    return SizedBox.expand(
      child: Stack(
        children: tiles,
      ),
    );
  }
}
