import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/activity_chart_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/continue_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/daily_progress_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/mini_calendar.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/welcome_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime focusedDay = DateTime.now();

  void _onCalendarPageChanged(DateTime newDate) {
    setState(() {
      focusedDay = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserDone) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WelcomeCard(
                      userFirstName: state.currentUser!.firstName,
                    ),
                    const SizedBox(height: 20),
                    ContinueCard(
                      user: state.currentUser!,
                    ),
                    const SizedBox(height: 28),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Today's Activity",
                        style: darkTextTheme().displaySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: GlassContainer(
                            shadowStrength: 2,
                            shadowColor: Colors.black,
                            blur: 4,
                            color: Colors.white.withOpacity(0.25),
                            child: DailyProgressCard(
                              todaySession:
                                  state.currentUser!.getCurrentSession(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 5,
                          child: GlassContainer(
                            shadowStrength: 2,
                            shadowColor: Colors.black,
                            blur: 4,
                            color: Colors.white.withOpacity(0.25),
                            child: ActivityChartCard(user: state.currentUser!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Text(
                          "Activity Monitor",
                          style: darkTextTheme().displaySmall,
                        ),
                        const Spacer(),
                        Text(
                          "${getMonth(focusedDay.month)} ${focusedDay.year}",
                          style: const TextStyle(
                            fontFamily: "Sailec Medium",
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    MiniCalendar(
                      user: state.currentUser!,
                      dateColorsMap: state.currentUser!.getDateColorsMap(),
                      focusedDay: focusedDay,
                      onPageChanged: _onCalendarPageChanged,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
