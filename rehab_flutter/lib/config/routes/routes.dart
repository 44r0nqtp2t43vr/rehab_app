import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/piano_tiles/domain/entities/song.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/pages/play_game/play_game.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/pages/song_select/song_select.dart';
import 'package:rehab_flutter/main.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(WelcomeScreen());

      case '/SongSelect':
        return _materialRoute(const SongSelect());

      case '/PlayGame':
        return _materialRoute(PlayGame(song: settings.arguments as Song));

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
