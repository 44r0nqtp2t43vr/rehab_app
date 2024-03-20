import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';

class ImgTile extends StatelessWidget {
  final double height;
  final double width;
  final int rotateFactor;
  final ImageTexture imgTexture;

  const ImgTile({
    required Key key,
    required this.height,
    required this.width,
    required this.rotateFactor,
    required this.imgTexture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: imgTexture.image.isNotEmpty
          ? Transform.rotate(
              angle: (pi / 2) * rotateFactor,
              child: AspectRatio(
                aspectRatio: width / height,
                child: Transform.scale(
                  scale: rotateFactor % 2 == 0 ? 1.0 : height / width,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      imgTexture.image,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
