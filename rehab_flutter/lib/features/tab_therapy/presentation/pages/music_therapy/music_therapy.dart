import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/core/widgets/app_iconbutton.dart';
import 'package:rehab_flutter/features/tab_therapy/domain/enums/mtscreen_enums.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/hover_song_card.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/mtscreen_all.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/mtscreen_genres.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/mtscreen_playlist.dart';
import 'package:rehab_flutter/injection_container.dart';

class MusicTherapyScreen extends StatefulWidget {
  const MusicTherapyScreen({super.key});

  @override
  State<MusicTherapyScreen> createState() => _MusicTherapyScreenState();
}

class _MusicTherapyScreenState extends State<MusicTherapyScreen> {
  late MTScreen screenState;

  @override
  void initState() {
    final selectedGenre = sl<NavigationController>().getSelectedGenre();
    screenState = selectedGenre == null ? MTScreen.all : MTScreen.genres;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<NavigationController>().setSelectedGenre(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () => _onBackButtonPressed(context),
              ),
              // AppIconButton(
              //   icon: Icons.chevron_left,
              //   onPressed: () => _onBackButtonPressed(context),
              // ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Music",
                      style: darkTextTheme().headlineLarge,
                    ),
                    Text(
                      "Stimulation",
                      style: darkTextTheme().headlineSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
          child: Row(
            children: [
              musicTopButtons(
                context: context,
                onPressed: () => _onAllButtonPressed(context),
                icon: CupertinoIcons.music_note_list,
                title: 'All',
                isActive: screenState == MTScreen.all,
              ),
              const SizedBox(width: 12),
              musicTopButtons(
                context: context,
                onPressed: () => _onGenresButtonPressed(context),
                icon: CupertinoIcons.music_albums_fill,
                title: 'Genres',
                isActive: screenState == MTScreen.genres,
              ),
              const SizedBox(width: 12),
              musicTopButtons(
                context: context,
                onPressed: () => _onPlaylistButtonPressed(context),
                icon: CupertinoIcons.heart_fill,
                title: 'Playlist',
                isActive: screenState == MTScreen.playlist,
              ),
              // AppButton(
              //   onPressed: () => _onAllButtonPressed(context),
              //   child: const Text('All'),
              // ),
              // AppButton(
              //   onPressed: () => _onGenresButtonPressed(context),
              //   child: const Text('Genres'),
              // ),
              // AppButton(
              //   onPressed: () => _onPlaylistButtonPressed(context),
              //   child: const Text('Playlist'),
              // ),
            ],
          ),
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
        return const MTScreenAll();
      case MTScreen.genres:
        return const MTScreenGenres();
      case MTScreen.playlist:
        return const MTScreenPlaylist();
      default:
        return Container();
    }
  }

  void _onBackButtonPressed(BuildContext context) {
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.home);
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
