import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_state.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/continue_card.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/take_test_button.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/pages/music_therapy/music_therapy.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/pages/specific_genre/specific_genre.dart';
import 'package:rehab_flutter/injection_container.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key});

  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  Widget buildTherapyScreenHome() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserDone) {
          final patient = state.currentUser!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Therapy",
                          style: darkTextTheme().headlineLarge,
                        ),
                        Text(
                          "Treatment",
                          style: darkTextTheme().headlineSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<PatientCurrentSessionBloc, PatientCurrentSessionState>(
                        builder: (context, state) {
                          if (state is PatientCurrentSessionLoading) {
                            return const Center(child: CupertinoActivityIndicator(color: Colors.white));
                          }

                          if (state is PatientCurrentSessionDone) {
                            final currentSession = state.currentSession!;

                            return Column(
                              children: [
                                currentSession.testingItems.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: TakeTestButton(),
                                      )
                                    : const SizedBox(),
                                ContinueCard(
                                  user: patient,
                                  session: state.currentSession!,
                                ),
                              ],
                            );
                          }

                          return Center(
                            child: Text(
                              "An error occurred while loading current session",
                              textAlign: TextAlign.center,
                              style: darkTextTheme().headlineSmall,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),
                      Text(
                        "Free Play",
                        style: darkTextTheme().displaySmall,
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          SizedBox(
                            height: 240,
                            child: Row(
                              children: [
                                cuButton(
                                  context: context,
                                  onPressed: () => _onMTButtonPressed(),
                                  title: 'Music',
                                  subTitle: 'Stimulation',
                                  svgPath: 'assets/images/wave1.svg',
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                cuButton(
                                  context: context,
                                  onPressed: () => _onCTButtonPressed(),
                                  title: 'Cutaneous',
                                  subTitle: 'Stimulation',
                                  svgPath: 'assets/images/cutaneous.svg',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget getScreenFromTabTherapy(TabTherapyEnum currentTabTherapy) {
    switch (currentTabTherapy) {
      case TabTherapyEnum.home:
        return buildTherapyScreenHome();
      case TabTherapyEnum.music:
        return const MusicTherapyScreen();
      case TabTherapyEnum.specificGenre:
        return const SpecificGenre();
      default:
        return buildTherapyScreenHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<NavigationController>(
      builder: (context) {
        final currentTabTherapy = sl<NavigationController>().getTherapyTab();
        return getScreenFromTabTherapy(currentTabTherapy);
      },
    );
  }

  void _onMTButtonPressed() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          content: GlassContainer(
            blur: 10,
            color: Colors.white.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/wave1.svg',
                        width: MediaQuery.of(context).size.width * .06,
                        height: MediaQuery.of(context).size.height * .06,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Music",
                              style: TextStyle(
                                fontFamily: 'Sailec Bold',
                                fontSize: 22,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Stimulation",
                              style: TextStyle(
                                fontFamily: 'Sailec Light',
                                fontSize: 16,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  cuButtonDialog(
                    context: context,
                    onPressed: () => _onBasicMTButtonPressed(context),
                    title: 'Basic',
                    svgPath: 'assets/images/basic.svg',
                  ),
                  const SizedBox(height: 20),
                  cuButtonDialog(
                    context: context,
                    onPressed: () => _onIntermediateMTButtonPressed(context),
                    title: 'Intermediate',
                    svgPath: 'assets/images/intermediate.svg',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Theme(
                        data: darkButtonTheme,
                        child: ElevatedButton(
                          onPressed: () => _onBackButtonPressed(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onBasicMTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    sl<SongController>().setMTType(MusicTherapy.basic);
    sl<SongController>().setSong(null);
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.music);
  }

  void _onIntermediateMTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    sl<SongController>().setMTType(MusicTherapy.intermediate);
    sl<SongController>().setSong(null);
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.music);
  }

  void _onCTButtonPressed() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          content: GlassContainer(
            blur: 10,
            color: Colors.white.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/cutaneous.svg',
                        width: MediaQuery.of(context).size.width * .06,
                        height: MediaQuery.of(context).size.height * .06,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cutaneous",
                              style: TextStyle(
                                fontFamily: 'Sailec Bold',
                                fontSize: 22,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Stimulation",
                              style: TextStyle(
                                fontFamily: 'Sailec Light',
                                fontSize: 16,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  cuButtonDialog(
                    context: context,
                    onPressed: () => _onATButtonPressed(context),
                    title: 'Point',
                    svgPath: 'assets/images/actuator.svg',
                  ),
                  const SizedBox(height: 12),
                  cuButtonDialog(
                    context: context,
                    onPressed: () => _onPTButtonPressed(context),
                    title: 'Pattern',
                    svgPath: 'assets/images/pattern.svg',
                  ),
                  const SizedBox(height: 12),
                  cuButtonDialog(
                    context: context,
                    onPressed: () => _onTTButtonPressed(context),
                    title: 'Texture',
                    svgPath: 'assets/images/texture.svg',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Theme(
                        data: darkButtonTheme,
                        child: ElevatedButton(
                          onPressed: () => _onBackButtonPressed(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onATButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/ActuatorTherapy');
  }

  void _onPTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/PatternTherapy');
  }

  void _onTTButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushNamed(context, '/TextureTherapy');
  }

  void _onBackButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
