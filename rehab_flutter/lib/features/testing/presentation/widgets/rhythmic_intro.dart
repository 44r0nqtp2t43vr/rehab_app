import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';

class RhythmicPatternsIntro extends StatefulWidget {
  final void Function(TestingState) onProceed;

  const RhythmicPatternsIntro({super.key, required this.onProceed});

  @override
  State<RhythmicPatternsIntro> createState() => _RhythmicPatternsIntroState();
}

class _RhythmicPatternsIntroState extends State<RhythmicPatternsIntro> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                onPressed: () => widget.onProceed(TestingState.rhythmicPatterns),
                child: const Text('Proceed'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
