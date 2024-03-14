import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class TestingFinish extends StatelessWidget {
  final List<double> accuracyList;

  const TestingFinish({super.key, required this.accuracyList});

  void _onFinish(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text((accuracyList.reduce((value, element) => value + element) / accuracyList.length).toStringAsFixed(2)),
              Text(accuracyList.toString()),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                onPressed: () => _onFinish(context),
                child: const Text('Finish'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
