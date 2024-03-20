import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserDone) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.currentUser!.userId),
              AppButton(
                onPressed: () => _onTestingButtonPressed(context),
                child: const Text('Pretest'),
              ),
              AppButton(
                  onPressed: () => _onPlanSelectionButtonPressed(context),
                  child: const Text('Select Plan'))
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  void _onTestingButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Testing');
  }

  void _onPlanSelectionButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PlanSelection');
  }
}
