import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/testing/domain/entities/pretest_data.dart';

class TestingFinish extends StatefulWidget {
  final List<String> itemList;
  final List<double> accuracyList;

  const TestingFinish({super.key, required this.itemList, required this.accuracyList});

  @override
  State<TestingFinish> createState() => _TestingFinishState();
}

class _TestingFinishState extends State<TestingFinish> {
  late double score;

  void _submitPretest(AppUser user, double score) {
    BlocProvider.of<UserBloc>(context).add(SubmitPretestEvent(PretestData(user: user, score: score)));
  }

  @override
  void initState() {
    final currentUser = BlocProvider.of<UserBloc>(context).state.currentUser!;
    score = (widget.accuracyList.reduce((value, element) => value + element) / widget.accuracyList.length);
    _submitPretest(currentUser, score);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        }
        if (state is UserDone) {
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(score.toStringAsFixed(2)),
                    Text(widget.accuracyList.toString()),
                    Text(widget.itemList.toString()),
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
        return const SizedBox();
      },
    );
  }

  void _onFinish(BuildContext context) {
    Navigator.of(context).pop();
  }
}
