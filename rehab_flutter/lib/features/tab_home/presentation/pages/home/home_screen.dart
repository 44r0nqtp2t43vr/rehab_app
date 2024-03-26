import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/activity_chart_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/continue_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/daily_progress_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/mini_calendar.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/welcome_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserDone) {
          final Session? todaySession = state.currentUser!.getCurrentSession();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WelcomeCard(userFirstName: state.currentUser!.firstName),
                const SizedBox(height: 20),
                Expanded(
                  flex: 1,
                  child: ContinueCard(
                    user: state.currentUser!,
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Today's Activity",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: DailyProgressCard(
                          todaySession: todaySession,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        flex: 5,
                        child: ActivityChartCard(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Activity Monitor",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: MiniCalendar(user: state.currentUser!),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
