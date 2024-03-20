import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/core/widgets/app_iconbutton.dart';
import 'package:rehab_flutter/features/tab_therapy/domain/enums/mtscreen_enums.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/hover_song_card.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/mtscreen_all.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/mtscreen_genres.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/mtscreen_playlist.dart';
import 'package:rehab_flutter/injection_container.dart';

class MusicTherapyScreen extends StatefulWidget {
  final void Function(TabTherapyEnum) callback;

  const MusicTherapyScreen({super.key, required this.callback});

  @override
  State<MusicTherapyScreen> createState() => _MusicTherapyScreenState();
}

class _MusicTherapyScreenState extends State<MusicTherapyScreen> {
  MTScreen screenState = MTScreen.all;

  void setSong(BuildContext context, Song song) {
    MusicTherapy mtType = sl<SongController>().currentMTType;
    sl<SongController>().setSong(song);
    sl<SongController>().setCurrentDuration(0);

    if (mtType == MusicTherapy.basic) {
      Navigator.pushReplacementNamed(context, '/PlayGame');
    } else if (mtType == MusicTherapy.intermediate) {
      Navigator.pushReplacementNamed(context, '/VisualizerScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AppIconButton(
              icon: Icons.chevron_left,
              onPressed: () => _onBackButtonPressed(context),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Music",
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    "Music",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            AppButton(
              onPressed: () => _onAllButtonPressed(context),
              child: const Text('All'),
            ),
            AppButton(
              onPressed: () => _onGenresButtonPressed(context),
              child: const Text('Genres'),
            ),
            AppButton(
              onPressed: () => _onPlaylistButtonPressed(context),
              child: const Text('Playlist'),
            ),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              _getWidgetFromMTScreenState(),
              const Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: HoverSongCard(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getWidgetFromMTScreenState() {
    switch (screenState) {
      case MTScreen.all:
        return MTScreenAll(callback: setSong);
      case MTScreen.genres:
        return const MTScreenGenres();
      case MTScreen.playlist:
        return const MTScreenPlaylist();
      default:
        return Container();
    }
  }

  void _onBackButtonPressed(BuildContext context) {
    widget.callback(TabTherapyEnum.home);
  }

  void _onAllButtonPressed(BuildContext context) {
    if (screenState != MTScreen.all) {
      setState(() {
        screenState = MTScreen.all;
      });
    }
  }

  void _onGenresButtonPressed(BuildContext context) {
    if (screenState != MTScreen.genres) {
      setState(() {
        screenState = MTScreen.genres;
      });
    }
  }

  void _onPlaylistButtonPressed(BuildContext context) {
    if (screenState != MTScreen.playlist) {
      setState(() {
        screenState = MTScreen.playlist;
      });
    }
  }
}
