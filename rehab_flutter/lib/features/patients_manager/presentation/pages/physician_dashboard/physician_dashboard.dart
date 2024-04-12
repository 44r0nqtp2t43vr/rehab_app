import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/welcome_card.dart';

class PhysicianDashboard extends StatefulWidget {
  const PhysicianDashboard({super.key});

  @override
  State<PhysicianDashboard> createState() => _PhysicianDashboardState();
}

class _PhysicianDashboardState extends State<PhysicianDashboard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhysicianBloc, PhysicianState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Column(
                children: [
                  WelcomeCard(
                    userFirstName: state.currentPhysician!.firstName.capitalize!,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
