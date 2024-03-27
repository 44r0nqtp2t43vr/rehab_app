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
  final List<String> itemList = [];
  final List<double> accuracyList = [];
  final int numOfStaticPatternsItems = 10;
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

  void onResponse(double newAccuracy, String newItem) {
    setState(() {
      itemList.add(newItem);
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

  String getTitleFromTestingState() {
    switch (testingState) {
      case TestingState.staticPatterns:
        return "Static Patterns Test";
      case TestingState.texturesIntro:
        return "Textures Introduction";
      case TestingState.textures:
        return "Textures Test";
      case TestingState.rhythmicPatternsIntro:
        return "Rhythmic Patterns Introduction";
      case TestingState.rhythmicPatterns:
        return "Rhythmic Patterns Test";
      case TestingState.finished:
        return "Results";
      default:
        return "";
    }
  }

  Widget getWidgetFromTestingState() {
    switch (testingState) {
      case TestingState.staticPatterns:
        return StaticPatternsTester(
          onResponse: onResponse,
          currentItemNo: currentItemInd + 1,
          totalItemNo: numOfStaticPatternsItems,
          currentStaticPattern: staticPatternsList[currentItemInd],
        );
      case TestingState.texturesIntro:
        return TexturesIntro(onProceed: onProceed);
      case TestingState.textures:
        return TexturesTester(
          onResponse: onResponse,
          currentItemNo: (currentItemInd + 1) - numOfStaticPatternsItems,
          totalItemNo: numOfTexturesItems,
          currentImageTexture: imageTexturesList[currentItemInd - numOfStaticPatternsItems],
        );
      case TestingState.rhythmicPatternsIntro:
        return RhythmicPatternsIntro(onProceed: onProceed);
      case TestingState.rhythmicPatterns:
        return RhythmicPatternsTester(
          onResponse: onResponse,
          currentItemNo: (currentItemInd + 1) - numOfStaticPatternsItems - numOfTexturesItems,
          totalItemNo: numOfRhythmicPatternsItems,
          currentRhythmicPattern: rhythmicPatternsList[currentItemInd - numOfStaticPatternsItems - numOfTexturesItems],
        );
      case TestingState.finished:
        return TestingFinish(itemList: itemList, accuracyList: accuracyList);
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
      appBar: _buildAppBar(),
      body: currentTestingWidget,
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pre-test",
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
          ),
          Text(
            getTitleFromTestingState(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
