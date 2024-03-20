import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/injection_container.dart';

class TextureFrame extends StatefulWidget {
  final ImageTexture imageTexture;

  const TextureFrame({Key? key, required this.imageTexture}) : super(key: key);

  @override
  TextureFrameState createState() => TextureFrameState(); // Adjusted here
}

class TextureFrameState extends State<TextureFrame> {
  // void _onTapImage(BuildContext context, dynamic details) {
  //   RenderBox box = context.findRenderObject() as RenderBox;
  //   final Offset localPosition = box.globalToLocal(details.globalPosition);

  //   final double displayWidth = box.size.width;
  //   final double displayHeight = box.size.height;
  //   final double scaleX = photo.width / displayWidth;
  //   final double scaleY = photo.height / displayHeight;

  //   double adjustedX = localPosition.dx;
  //   double adjustedY = localPosition.dy;

  //   if (photo.width / photo.height > displayWidth / displayHeight) {
  //     // Adjust for wide image
  //     double scaledHeight = displayWidth / (photo.width / photo.height);
  //     adjustedY = (localPosition.dy - (displayHeight - scaledHeight) / 2) * scaleY;
  //   } else {
  //     // Adjust for tall image
  //     double scaledWidth = displayHeight * (photo.width / photo.height);
  //     adjustedX = (localPosition.dx - (displayWidth - scaledWidth) / 2) * scaleX;
  //   }

  //   tapPositions.clear();
  //   tappedColors.clear();

  //   // Increase the spacing to 20 points instead of 10
  //   int spacing = 10; // Adjust the spacing value as needed

  //   // Correct loop to generate positions with increased spacing
  //   for (int i = -1; i <= 2; i++) {
  //     for (int j = -1; j <= 2; j++) {
  //       final double gridX = adjustedX + (j * spacing) * scaleX;
  //       final double gridY = adjustedY + (i * spacing) * scaleY;

  //       final int imageX = max(0, min(photo.width - 1, gridX.round()));
  //       final int imageY = max(0, min(photo.height - 1, gridY.round()));

  //       final img.Pixel pixel = photo.getPixelSafe(imageX, imageY);
  //       bool isWhite = pixel.r >= 235 && pixel.g >= 235 && pixel.b >= 235;
  //       tappedColors.add(!isWhite ? Colors.green : Color.fromRGBO(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 1.0));

  //       // Adjust position back to display space
  //       tapPositions.add(Offset(gridX / scaleX, gridY / scaleY));
  //     }
  //   }

  //   setState(() {});
  //   sendPattern();
  // }

  @override
  void initState() {
    super.initState();
  }

  void _renderActuators(BuildContext context, dynamic details) {
    if (details != null) {
      RenderBox box = context.findRenderObject() as RenderBox;
      final Offset localPosition = box.globalToLocal(details.globalPosition);
      sl<ActuatorsBloc>().add(UpdateActuatorsEvent(localPosition));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _renderActuators(context, details),
      onPanUpdate: (details) => _renderActuators(context, details),
      child: Stack(
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imageTexture.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ...sl<ActuatorsController>().buildActuators(),
        ],
      ),
    );
  }
}
