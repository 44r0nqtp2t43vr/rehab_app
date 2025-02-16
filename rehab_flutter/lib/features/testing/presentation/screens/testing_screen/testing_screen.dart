import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/testing/data/data_sources/testing_data_provider.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';
import 'package:rehab_flutter/features/testing/domain/entities/static_pattern.dart';
import 'package:rehab_flutter/features/testing/domain/entities/tdt_pair.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/tdt_pairs_tester.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/testing_finish.dart';
import 'package:rehab_flutter/features/testing/presentation/widgets/twopd_patterns_tester.dart';
import 'package:rehab_flutter/injection_container.dart';

class TestingScreen extends StatefulWidget {
  final bool isPretest;

  const TestingScreen({super.key, required this.isPretest});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  final List<String> itemList = [];
  final List<String> answerList = [];
  // final List<double> accuracyList = [];
  // final int numOfStaticPatternsItems = 10;
  final int numOfTwoPDPatternsItems = 10;
  // final int numOfTexturesItems = 5;
  // final int numOfRhythmicPatternsItems = 5;
  final int numOfTdtPairsItems = 10;
  late Widget currentTestingWidget;
  // late List<StaticPattern> staticPatternsList;
  late List<StaticPattern> twoPDPatternsList;
  // late List<ImageTexture> imageTexturesList;
  // late List<RhythmicPattern> rhythmicPatternsList;
  late List<TdtPair> tdtPairsList;
  TestingState testingState = TestingState.twoPointDiscrimination;
  int currentItemInd = 0;

  void skipTest(BuildContext context) {
    final user = BlocProvider.of<UserBloc>(context).state.currentUser!;
    final currentSession = BlocProvider.of<PatientCurrentSessionBloc>(context).state.currentSession!;

    BlocProvider.of<UserBloc>(context).add(SubmitTestEvent(
      ResultsData(
        user: user,
        currentSession: currentSession,
        items: [""],
      ),
    ));
    Navigator.of(context).pop(true);
  }

  void onProceed(TestingState newTestingState) {
    setState(() {
      testingState = newTestingState;
      currentTestingWidget = getWidgetFromTestingState();
    });
  }

  void onResponse(String newItem, String newAnswer) {
    setState(() {
      itemList.add(newItem);
      answerList.add(newAnswer);
      // accuracyList.add(newAccuracy);
      currentItemInd++;

      if (currentItemInd == numOfTwoPDPatternsItems) {
        testingState = TestingState.tactileDiscrimination;
      } else if (currentItemInd == numOfTwoPDPatternsItems + numOfTdtPairsItems) {
        testingState = TestingState.finished;
      }

      currentTestingWidget = getWidgetFromTestingState();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.white.withValues(alpha: 0.3),
        content: Text('Submitted Response', style: darkTextTheme().displaySmall),
      ),
    );

    sl<BluetoothBloc>().add(const WriteDataEvent("<000000000000000000000000000000>"));
    // debugPrint(accuracyList.toString());
  }

  String getTitleFromTestingState() {
    switch (testingState) {
      case TestingState.twoPointDiscrimination:
        return "2-Point Discrimination Test";
      case TestingState.tactileDiscrimination:
        return "Tactile Discrimination Test";
      case TestingState.finished:
        return "Results";
    }
  }

  Widget getWidgetFromTestingState() {
    switch (testingState) {
      case TestingState.twoPointDiscrimination:
        // return StaticPatternsTester(
        //   onResponse: onResponse,
        //   currentItemNo: currentItemInd + 1,
        //   totalItemNo: numOfStaticPatternsItems,
        //   currentStaticPattern: staticPatternsList[currentItemInd],
        // );
        return TwoPDPatternsTester(
          onResponse: onResponse,
          currentItemNo: currentItemInd + 1,
          totalItemNo: numOfTwoPDPatternsItems,
          currentStaticPattern: twoPDPatternsList[currentItemInd],
        );
      // case TestingState.rhythmicPatternsIntro:
      //   return RhythmicPatternsIntro(onProceed: onProceed);
      // case TestingState.rhythmicPatterns:
      //   return RhythmicPatternsTester(
      //     onResponse: onResponse,
      //     currentItemNo: (currentItemInd + 1) - numOfTwoPDPatternsItems,
      //     totalItemNo: numOfRhythmicPatternsItems,
      //     currentRhythmicPattern: rhythmicPatternsList[currentItemInd - numOfTwoPDPatternsItems],
      //   );
      // case TestingState.texturesIntro:
      //   return TexturesIntro(onProceed: onProceed);
      // case TestingState.textures:
      //   return TexturesTester(
      //     onResponse: onResponse,
      //     currentItemNo: (currentItemInd + 1) - numOfTwoPDPatternsItems - numOfRhythmicPatternsItems,
      //     totalItemNo: numOfTexturesItems,
      //     currentImageTexture: imageTexturesList[currentItemInd - numOfTwoPDPatternsItems - numOfRhythmicPatternsItems],
      //   );
      case TestingState.tactileDiscrimination:
        final currentTdtPair = tdtPairsList[currentItemInd - numOfTwoPDPatternsItems];
        return TdtPairsTester(
          onResponse: onResponse,
          currentItemNo: (currentItemInd + 1) - numOfTwoPDPatternsItems,
          totalItemNo: numOfTdtPairsItems,
          currentTdtPair: currentTdtPair,
          optionsList: currentTdtPair.getRandomizedList(),
        );
      case TestingState.finished:
        return TestingFinish(itemList: itemList, answerList: answerList);
    }
  }

  @override
  void initState() {
    super.initState();

    final Random random = Random();

    // staticPatternsList = List.from(TestingDataProvider.staticPatterns);
    twoPDPatternsList = List.from(TestingDataProvider.twoPDPatterns);
    // imageTexturesList = List.from(TestingDataProvider.imageTextures);
    // rhythmicPatternsList = List.from(TestingDataProvider.rhythmicPatterns);
    tdtPairsList = List.from(TestingDataProvider.tdtPairs);

    // staticPatternsList.shuffle(random);
    twoPDPatternsList.shuffle(random);
    // imageTexturesList.shuffle(random);
    // rhythmicPatternsList.shuffle(random);
    tdtPairsList.shuffle(random);

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
      leading: IconButton(
        icon: const Icon(
          Icons.chevron_left,
          size: 35,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // widget.isPretest ? "Pre-test" : "Post-test",
            "Weekly Test",
            style: darkTextTheme().headlineLarge,
          ),
          Text(
            getTitleFromTestingState(),
            style: darkTextTheme().headlineSmall,
          ),
        ],
      ),
      actions: const [
        // IconButton(
        //   icon: const Icon(
        //     Icons.check,
        //     size: 35,
        //     color: Colors.white,
        //   ),
        //   onPressed: () => skipTest(context),
        // ),
      ],
    );
  }
}
