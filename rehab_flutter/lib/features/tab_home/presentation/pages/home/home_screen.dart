import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Hi, ${state.currentUser!.firstName.capitalize!}",
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        const Text(
                          "Welcome to cu.touch",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: AppButton(
                  onPressed: () => _onTestingButtonPressed(context),
                  child: const Text('Pretest'),
                ),
              ),
              const Text(
                "Today's Activity",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(),
              ),
              const Text(
                "Activity Monitor",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    AppButton(onPressed: () => _onPlanSelectionButtonPressed(context), child: const Text('Select Plan')),
                    AppButton(
                      onPressed: () => _onTodaysSessionPressed(context),
                      child: const Text('Today\'s Session'),
                    )
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

  void _onTodaysSessionPressed(BuildContext context) {
    Navigator.pushNamed(context, '/TodaysSession');
  }

  void _onTestingButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/Testing');
  }

  void _onPlanSelectionButtonPressed(BuildContext context) {
    Navigator.pushNamed(context, '/PlanSelection');
  }
}
