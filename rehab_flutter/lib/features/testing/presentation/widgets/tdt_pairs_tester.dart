import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_bloc.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_event.dart';
import 'package:rehab_flutter/core/bloc/actuators/actuators_state.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/actuators_controller.dart';
import 'package:rehab_flutter/core/data_sources/anipattern_provider.dart';
import 'package:rehab_flutter/core/entities/actuators_initdata.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/core/enums/actuators_enums.dart';
import 'package:rehab_flutter/core/interface/actuators_repository.dart';
import 'package:rehab_flutter/features/testing/domain/entities/tdt_pair.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/test_label.dart';
import 'package:rehab_flutter/injection_container.dart';

class TdtPairsTester extends StatefulWidget {
  final void Function(String, String) onResponse;
  final TdtPair currentTdtPair;
  final int currentItemNo;
  final int totalItemNo;
  final List<ImageTexture> optionsList;

  const TdtPairsTester({
    super.key,
    required this.onResponse,
    required this.currentTdtPair,
    required this.currentItemNo,
    required this.totalItemNo,
    required this.optionsList,
  });

  @override
  State<TdtPairsTester> createState() => _TdtPairsTesterState();
}

class _TdtPairsTesterState extends State<TdtPairsTester> with SingleTickerProviderStateMixin {
  // Timer? _timer;
  late AnimationController animationController;
  ImageTexture? _selectedTexture;
  bool isPlaying = false;

  // double _calculateAccuracy(String answer) {
  //   return answer == widget.currentStaticPattern.name[0] ? 100 : 0;
  // }

  void _onSubmit(String answer) {
    // _timer?.cancel();
    _onAnimationFinish();
    setState(() {
      _selectedTexture = null;
      isPlaying = false;
    });
    widget.onResponse("${widget.currentTdtPair.answer.name} & ${widget.currentTdtPair.distractor.name}", answer);
  }

  // void _sendPattern() {
  //   String currentPatternString = widget.currentStaticPattern.pattern;
  //   String data = "";
  //   switch (widget.currentStaticPattern.fingerNum) {
  //     case 0:
  //       data = "<${currentPatternString}000000000000000000000000>";
  //       break;
  //     case 1:
  //       data = "<000000${currentPatternString}000000000000000000>";
  //       break;
  //     case 2:
  //       data = "<000000000000${currentPatternString}000000000000>";
  //       break;
  //     case 3:
  //       data = "<000000000000000000${currentPatternString}000000>";
  //       break;
  //     case 4:
  //       data = "<000000000000000000000000${currentPatternString}>";
  //       break;
  //     case 5:
  //       data = "<$currentPatternString$currentPatternString$currentPatternString$currentPatternString$currentPatternString>";
  //       break;
  //     default:
  //       data = "<$currentPatternString$currentPatternString$currentPatternString$currentPatternString$currentPatternString>";
  //       break;
  //   }

  //   sl<BluetoothBloc>().add(WriteDataEvent(data));
  //   debugPrint("Pattern sent: $data");
  // }

  // void _sendPatternRepeatedly() {
  //   // Cancel the previous timer if it exists
  //   _timer?.cancel();

  //   // Schedule a new timer to call _sendPattern every 3 seconds
  //   _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
  //     sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
  //     await Future.delayed(const Duration(milliseconds: 200));
  //     _sendPattern();
  //   });
  // }

  void _onAnimationStart(ImageTexture newSelectedTexture, int desiredSize) async {
    _onAnimationFinish();
    // sl<ActuatorsBloc>().add(InitActuatorsEvent(ActuatorsInitData(
    //   imgSrc: _selectedTexture!.texture,
    //   orientation: ActuatorsOrientation.landscape,
    //   numOfFingers: ActuatorsNumOfFingers.five,
    //   imagesHeight: desiredSize,
    //   imagesWidth: desiredSize,
    // )));
    await sl<ActuatorsRepository>().initializeActuators(ActuatorsInitData(
      imgSrc: newSelectedTexture.texture,
      orientation: ActuatorsOrientation.landscape,
      numOfFingers: ActuatorsNumOfFingers.five,
      imagesHeight: desiredSize,
      imagesWidth: desiredSize,
    ));
    setState(() {
      _selectedTexture = newSelectedTexture;
    });
    isPlaying = true;
    animationController.forward();
  }

  void _onAnimationFinish() {
    animationController.reset();
    // if (currentImageTextureInd < TestingDataProvider.imageTextures.length - 1) {
    //   setState(() {
    //     currentImageTextureInd++;
    //     currentImageTexture = TestingDataProvider.imageTextures[currentImageTextureInd];
    //     isPlaying = true;
    //   });
    //   sl<ActuatorsBloc>().add(LoadImageEvent(ActuatorsImageData(src: currentImageTexture.texture, preload: false)));
    //   animationController.forward();
    // }
  }

  void _renderActuators(double imageSize) {
    final Offset animatedPosition = AniPatternProvider.verticalPattern(imageSize, animationController.value);
    sl<ActuatorsBloc>().add(UpdateActuatorsEvent(animatedPosition));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // _sendPattern();
    // _sendPatternRepeatedly();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isPlaying = false;
        });

        _onAnimationFinish();
      }
    });
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant TdtPairsTester oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTdtPair != oldWidget.currentTdtPair) {
      // _sendPattern();
      // _sendPatternRepeatedly();
    }
  }

  @override
  void dispose() {
    // _timer?.cancel();
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int desiredSize = MediaQuery.of(context).size.width.toInt();

    if (isPlaying) {
      _renderActuators(desiredSize.toDouble());
    }

    return Column(
      children: [
        const SizedBox(height: 32),
        TestLabel(label: "Item ${widget.currentItemNo} of ${widget.totalItemNo}"),
        const SizedBox(height: 16),
        // const Expanded(
        //   flex: 2,
        //   child:
        // ),
        const Spacer(),
        _selectedTexture == null
            ? const SizedBox()
            : BlocProvider(
                create: (_) => sl<ActuatorsBloc>()
                  ..add(InitActuatorsEvent(ActuatorsInitData(
                    imgSrc: _selectedTexture!.texture,
                    orientation: ActuatorsOrientation.landscape,
                    numOfFingers: ActuatorsNumOfFingers.five,
                    imagesHeight: desiredSize,
                    imagesWidth: desiredSize,
                  ))),
                child: SizedBox(
                  height: desiredSize.toDouble(),
                  child: _buildBody(_selectedTexture!, desiredSize),
                ),
              ),
        const Center(
          child: Text(
            "Click a button to feel the item's texture",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Sailec Medium',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ...widget.optionsList.asMap().entries.map(
              (option) {
                final index = option.key; // Get the index
                final tdtOption = option.value; // Get the value (item)

                return ElevatedButton(
                  onPressed: () => _onAnimationStart(tdtOption, desiredSize),
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
                  child: Text((index + 1).toString()),
                );
              },
            ).toList(),
            ElevatedButton(
              onPressed: () => _onAnimationFinish(),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(
                  Colors.white,
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.red, // Example color for the extra button
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
              child: const Text("Stop"), // Text for the extra button
            ),
          ],
        ),
        const Spacer(),
        const Center(
          child: Text(
            "Which item has a different texture?",
            style: TextStyle(
              fontFamily: 'Sailec Medium',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 1,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.optionsList.asMap().entries.map(
              (option) {
                final index = option.key; // Get the index
                final tdtOption = option.value; // Get the value (item)

                return ElevatedButton(
                  onPressed: () => _onSubmit(tdtOption.name),
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
                  child: Text((index + 1).toString()),
                );
              },
            ).toList(),
          ),
        ),
      ],
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
                    Container(
                      width: desiredSize.toDouble(),
                      height: desiredSize.toDouble(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(currentTexture.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ...sl<ActuatorsController>().buildActuators(),
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
