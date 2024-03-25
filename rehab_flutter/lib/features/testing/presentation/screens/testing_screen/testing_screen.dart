import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/entities/image_texture.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/entities/rhythmic_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/rhythmic_intro.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/rhythmic_patterns_tester.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/static_patterns_tester.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/testing_finish.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/textures_intro.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/textures_tester.dart';
import 'package:rehab_flutter/injection_container.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  final List<double> accuracyList = [];
  final int numOfStaticPatternsItems = 5;
  final int numOfTexturesItems = 5;
  final int numOfRhythmicPatternsItems = 5;
  late Widget currentTestingWidget;
  late List<StaticPattern> staticPatternsList;
  late List<ImageTexture> imageTexturesList;
  late List<RhythmicPattern> rhythmicPatternsList;
  TestingState testingState = TestingState.staticPatterns;
  int currentItemInd = 0;

  void onProceed(TestingState newTestingState) {
    setState(() {
      testingState = newTestingState;
      currentTestingWidget = getWidgetFromTestingState();
    });
  }

  void onResponse(double newAccuracy) {
    setState(() {
      accuracyList.add(newAccuracy);
      currentItemInd++;

      if (currentItemInd == numOfStaticPatternsItems) {
        testingState = TestingState.texturesIntro;
      } else if (currentItemInd == numOfStaticPatternsItems + numOfTexturesItems) {
        testingState = TestingState.rhythmicPatternsIntro;
      } else if (currentItemInd == numOfStaticPatternsItems + numOfTexturesItems + numOfRhythmicPatternsItems) {
        testingState = TestingState.finished;
      }

      currentTestingWidget = getWidgetFromTestingState();
    });
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    debugPrint(accuracyList.toString());
  }

  Widget getWidgetFromTestingState() {
    switch (testingState) {
      case TestingState.staticPatterns:
        return StaticPatternsTester(
          onResponse: onResponse,
          currentItemInd: currentItemInd,
          currentStaticPattern: staticPatternsList[currentItemInd],
        );
      case TestingState.texturesIntro:
        return TexturesIntro(onProceed: onProceed);
      case TestingState.textures:
        return TexturesTester(
          onResponse: onResponse,
          currentItemInd: currentItemInd,
          currentImageTexture: imageTexturesList[currentItemInd - numOfStaticPatternsItems],
        );
      case TestingState.rhythmicPatternsIntro:
        return RhythmicPatternsIntro(onProceed: onProceed);
      case TestingState.rhythmicPatterns:
        return RhythmicPatternsTester(
          onResponse: onResponse,
          currentItemInd: currentItemInd,
          currentRhythmicPattern: rhythmicPatternsList[currentItemInd - numOfStaticPatternsItems - numOfTexturesItems],
        );
      case TestingState.finished:
        return TestingFinish(accuracyList: accuracyList);
      default:
        return Container();
    }
  }

  @override
  void initState() {
    super.initState();

    final Random random = Random();

    staticPatternsList = List.from(TestingDataProvider.staticPatterns);
    imageTexturesList = List.from(TestingDataProvider.imageTextures);
    rhythmicPatternsList = List.from(TestingDataProvider.rhythmicPatterns);

    staticPatternsList.shuffle(random);
    imageTexturesList.shuffle(random);
    rhythmicPatternsList.shuffle(random);

    currentTestingWidget = getWidgetFromTestingState();
  }

  @override
  void dispose() {
    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing'),
      ),
      body: currentTestingWidget,
    );
  }
}
