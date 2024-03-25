import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/features/todays_session/presentation/todays_session.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/bluetooth_connect/bluetooth_connect_screen.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/bluetooth_screen/bluetooth_screen.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/main_screen/main_screen.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/service_screen/service_screen.dart';
import 'package:rehab_flutter/features/login_register/presentation/pages/login/login_screen.dart';
import 'package:rehab_flutter/features/login_register/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:rehab_flutter/features/login_register/presentation/pages/register/register_screen.dart';
import 'package:rehab_flutter/features/logs_screen/presentation/logs_screen.dart';
import 'package:rehab_flutter/features/passive_therapy/presenation/passive_therapy_screen.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/pages/play_game/play_game.dart';
import 'package:rehab_flutter/features/actuator_therapy/presentation/pages/actuator_therapy_screen.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/pages/pattern_therapy_screen.dart';
import 'package:rehab_flutter/features/plan_selection/presentation/plan_selection.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/pages/texture_therapy/texture_therapy.dart';
import 'package:rehab_flutter/features/scrolling_textures/presentation/pages/scroll_textures/scroll_textures.dart';
import 'package:rehab_flutter/features/testing/presentation/screens/testing_screen/testing_screen.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/screens/visualizer_screen.dart';
import 'package:rehab_flutter/injection_container.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const OnboardingScreen());

      case '/Onboarding':
        return _materialRoute(const OnboardingScreen());

      case '/Login':
        return _materialRoute(const LoginScreen());

      case '/Register':
        return _materialRoute(const RegisterScreen());

      case '/BluetoothConnect':
        return _materialRoute(const BluetoothConnectScreen());

      case '/BluetoothScreen':
        return _materialRoute(const BluetoothScreen());

      case '/ServiceScreen':
        return _materialRoute(ServiceScreen(targetDevice: settings.arguments as BluetoothDevice));

      case '/MainScreen':
        return _materialRoute(const MainScreen());

      case '/Testing':
        return _materialRoute(const TestingScreen());

      case '/PlayGame':
        return _materialRoute(PlayGame(
          song: sl<SongController>().getCurrentSong()!,
          startingNoteIndex: sl<SongController>().getCurrentDuration() ~/ 0.3,
        ));

      case '/ActuatorTherapy':
        return _materialRoute(const ActuatorTherapy());

      case '/PatternTherapy':
        return _materialRoute(const PatternTherapy());

      case '/Test':
        return _materialRoute(const PassiveTherapyScreen());

      case '/TextureTherapy':
        return _materialRoute(const TextureTherapy());

      case '/LogsScreen':
        return _materialRoute(const LogsScreen());

      case '/ScrollTextures':
        return _materialRoute(const ScrollTextures());

      case '/VisualizerScreen':
        return _materialRoute(VisualizerScreenSlider(songData: sl<SongController>().getCurrentSong()!));

      case '/PlanSelection':
        return _materialRoute(PlanSelection());

      case '/PassiveTherapy':
        return _materialRoute(const PassiveTherapyScreen());

      case '/TodaysSession':
        return _materialRoute(const TodaySessionScreen());
      default:
        return _materialRoute(const OnboardingScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view, maintainState: false);
  }
}
