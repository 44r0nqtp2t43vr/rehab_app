import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/piano_tiles/domain/entities/song.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/pages/play_game/play_game.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/pages/song_select/song_select.dart';
import 'package:rehab_flutter/features/actuator_therapy/presentation/pages/actuator_therapy_screen.dart';
import 'package:rehab_flutter/features/pattern_therapy/presentation/pages/pattern_therapy_screen.dart';
import 'package:rehab_flutter/features/scrolling_textures/presentation/pages/bg_song_select/bg_song_select.dart';
import 'package:rehab_flutter/features/scrolling_textures/presentation/pages/scroll_textures/scroll_textures.dart';
import 'package:rehab_flutter/features/texture_therapy/presentation/pages/texture_therapy_screen.dart';
import 'package:rehab_flutter/main.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/bluetooth_screen.dart';
import 'package:rehab_flutter/screens/menu_screen.dart';
import 'package:rehab_flutter/screens/test.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(WelcomeScreen());

      case '/SongSelect':
        return _materialRoute(const SongSelect());

      case '/PlayGame':
        return _materialRoute(PlayGame(song: settings.arguments as Song));

      case '/ActuatorTherapy':
        return _materialRoute(ActuatorTherapy());

      case '/PatternTherapy':
        return _materialRoute(const PatternTherapy());

      case '/Test':
        return _materialRoute(Test());

      case '/TextureTherapy':
        return _materialRoute(const TextureTherapy());

      case '/MenuScreen':
        return _materialRoute(MenuScreen());

      case '/BluetoothScreen':
        return _materialRoute(BluetoothScreen());

      case '/BgSongSelect':
        return _materialRoute(const BgSongSelect());

      case '/ScrollTextures':
        return _materialRoute(ScrollTextures(song: settings.arguments as Song));

      // case '/ViewDevices':
      //   return _materialRoute(const ViewDevices());

      // case '/ViewServices':
      //   return _materialRoute(
      //       ViewServices(targetDevice: settings.arguments as BluetoothDevice));

      default:
        return _materialRoute(WelcomeScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
