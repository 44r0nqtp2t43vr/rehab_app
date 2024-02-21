import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/entities/image_texture.dart';

class ImgTile extends StatelessWidget {
  final double height;
  final double width;
  final ImageTexture imgTexture;

  const ImgTile({
    required Key key,
    required this.height,
    required this.width,
    required this.imgTexture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: imgTexture.image.isNotEmpty
            ? DecorationImage(
                image: AssetImage(imgTexture.image),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}
