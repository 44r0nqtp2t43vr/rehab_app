import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/data_sources/anipattern_provider.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/features/texture_therapy/domain/enums/animation_direction.dart';
import 'package:rehab_flutter/injection_container.dart';

class ScrollTextureFrame extends StatefulWidget {
  final int imgSize;
  final ImageTexture imageTexture;
  final AnimationController animationController;
  final AnimationDirection animationDirection;
  final bool isPlaying;

  const ScrollTextureFrame(
      {super.key,
      required this.imgSize,
      required this.imageTexture,
      required this.animationController,
      required this.animationDirection,
      required this.isPlaying});

  @override
  State<ScrollTextureFrame> createState() => _ScrollTextureFrameState();
}

class _ScrollTextureFrameState extends State<ScrollTextureFrame> {
  @override
  void initState() {
    super.initState();
  }

  void _renderActuators(
      BuildContext context, dynamic details, double imageSize) {
    if (details != null) {
      RenderBox box = context.findRenderObject() as RenderBox;
      final Offset localPosition = box.globalToLocal(details.globalPosition);
      sl<ActuatorsBloc>().add(UpdateActuatorsEvent(localPosition));
    } else {
      final Offset animatedPosition =
          widget.animationDirection == AnimationDirection.vertical
              ? AniPatternProvider.verticalPattern(
                  imageSize, widget.animationController.value)
              : AniPatternProvider.horizontalPattern(
                  imageSize, widget.animationController.value);
      sl<ActuatorsBloc>().add(UpdateActuatorsEvent(animatedPosition));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (widget.isPlaying) {
      _renderActuators(context, null, screenWidth);
    }

    return GestureDetector(
      onTapDown: (details) => widget.isPlaying
          ? {}
          : _renderActuators(context, details, screenWidth),
      onPanUpdate: (details) => widget.isPlaying
          ? {}
          : _renderActuators(context, details, screenWidth),
      child: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenWidth,
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
