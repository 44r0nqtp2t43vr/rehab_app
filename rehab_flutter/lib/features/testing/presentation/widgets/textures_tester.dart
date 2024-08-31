import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_state.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/entities/actuators_imagedata.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/core/data_sources/anipattern_provider.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';
import 'package:rehab_flutter/injection_container.dart';

class TexturesTester extends StatefulWidget {
  final void Function(double, String) onResponse;
  final ImageTexture currentImageTexture;
  final int currentItemNo;
  final int totalItemNo;

  const TexturesTester({
    super.key,
    required this.onResponse,
    required this.currentImageTexture,
    required this.currentItemNo,
    required this.totalItemNo,
  });

  @override
  State<TexturesTester> createState() => _TexturesTesterState();
}

class _TexturesTesterState extends State<TexturesTester> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool isPlaying = false;

  void _onSubmit(String value) {
    setState(() {
      isPlaying = false;
    });
    widget.onResponse(value == widget.currentImageTexture.name ? 100 : 0, widget.currentImageTexture.name);
  }

  void _renderActuators(double imageSize) {
    final Offset animatedPosition = AniPatternProvider.doubleVPattern(imageSize, animationController.value);
    sl<ActuatorsBloc>().add(UpdateActuatorsEvent(animatedPosition));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isPlaying = false;
        });
        animationController.reset();
      }
    });
    animationController.addListener(() {
      setState(() {});
    });

    isPlaying = true;
    animationController.forward();
  }

  @override
  void didUpdateWidget(covariant TexturesTester oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentImageTexture != oldWidget.currentImageTexture) {
      sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(src: widget.currentImageTexture.texture, preload: false)));

      isPlaying = true;
      animationController.reset();
      animationController.forward();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int desiredSize = MediaQuery.of(context).size.width.toInt();

    if (isPlaying) {
      _renderActuators(desiredSize.toDouble());
    }

    return BlocProvider(
      create: (_) => sl<ActuatorsBloc>()
        ..add(InitActuatorsEvent(ActuatorsInitData(
          imgSrc: widget.currentImageTexture.texture,
          orientation: ActuatorsOrientation.landscape,
          numOfFingers: ActuatorsNumOfFingers.five,
          imagesHeight: desiredSize,
          imagesWidth: desiredSize,
        ))),
      child: Column(
        children: [
          const SizedBox(height: 32),
          TestLabel(label: "Item ${widget.currentItemNo} of ${widget.totalItemNo}"),
          const SizedBox(height: 16),
          Expanded(
            flex: 2,
            child: _buildBody(widget.currentImageTexture, desiredSize),
          ),
          const SizedBox(height: 4),
          const Text(
            "What texture do you feel?",
            style: TextStyle(
              fontFamily: 'Sailec Medium',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: TestingDataProvider.imageTextures.map(
              (imageTexture) {
                return ElevatedButton(
                  onPressed: () => _onSubmit(imageTexture.name),
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color(0xff128BED),
                    ),
                    elevation: WidgetStateProperty.all<double>(0),
                    shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                    overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(imageTexture.name),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBody(ImageTexture currentTexture, int desiredSize) {
    return BlocBuilder<ActuatorsBloc, ActuatorsState>(
      builder: (context, state) {
        if (state is ActuatorsLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is ActuatorsDone) {
          return Center(
            child: Column(
              children: <Widget>[
                const Spacer(),
                Stack(
                  children: [
                    SizedBox(
                      width: desiredSize.toDouble(),
                      height: desiredSize.toDouble(),
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage(currentTexture.image),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                    ),
                    ...sl<ActuatorsController>().buildActuatorsConstColor(),
                  ],
                ),
                const Spacer(),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
