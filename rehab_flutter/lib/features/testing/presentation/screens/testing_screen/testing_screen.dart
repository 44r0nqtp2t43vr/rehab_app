import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/rhythmic_patterns_tester.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/static_patterns_tester.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/textures_tester.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  final List<double> accuracyList = [];
  final int numOfStaticPatternsItems = 5;
  final int numOfTexturesItems = 1;
  final int numOfRhythmicPatternsItems = 1;
  late List<StaticPattern> staticPatternsList;
  TestingState testingState = TestingState.staticPatterns;
  int currentItemInd = 0;

  void onResponse(double newAccuracy) {
    setState(() {
      accuracyList.add(newAccuracy);
      currentItemInd++;
      if (currentItemInd < numOfStaticPatternsItems) {
        debugPrint(staticPatternsList[currentItemInd].pattern);
      }

      if (currentItemInd == numOfStaticPatternsItems) {
        testingState = TestingState.textures;
      } else if (currentItemInd == numOfStaticPatternsItems + numOfTexturesItems) {
        testingState = TestingState.rhythmicPatterns;
      }
    });
  }

  Widget getWidgetFromTestingState() {
    switch (testingState) {
      case TestingState.staticPatterns:
        return StaticPatternsTester(
          onResponse: onResponse,
          currentStaticPattern: staticPatternsList[currentItemInd],
        );
      case TestingState.texturesIntro:
        return Container();
      case TestingState.textures:
        return TexturesTester(onResponse: onResponse);
      case TestingState.rhythmicPatternsIntro:
        return Container();
      case TestingState.rhythmicPatterns:
        return RhythmicPatternsTester(onResponse: onResponse);
      default:
        return Container();
    }
  }

  @override
  void initState() {
    super.initState();

    final Random random = Random();
    final TestingDataProvider testingDataProvider = TestingDataProvider();
    staticPatternsList = List.from(testingDataProvider.staticPatterns);
    staticPatternsList.shuffle(random);

    debugPrint(staticPatternsList[currentItemInd].pattern);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing'),
      ),
      body: getWidgetFromTestingState(),
    );
  }
}
