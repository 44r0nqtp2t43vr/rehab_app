import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/testing/domain/enums/testing_enums.dart';

class TexturesIntro extends StatefulWidget {
  final void Function(TestingState) onProceed;

  const TexturesIntro({super.key, required this.onProceed});

  @override
  State<TexturesIntro> createState() => _TexturesIntroState();
}

class _TexturesIntroState extends State<TexturesIntro> {
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
                onPressed: () => widget.onProceed(TestingState.textures),
                child: const Text('Proceed'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
