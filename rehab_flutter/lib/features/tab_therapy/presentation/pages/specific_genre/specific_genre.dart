import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/data_sources/song_provider.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/enums/genre_enum.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/hover_song_card.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/song_card.dart';
import 'package:rehab_flutter/injection_container.dart';

class SpecificGenre extends StatelessWidget {
  const SpecificGenre({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedGenre = sl<NavigationController>().getSelectedGenre();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedGenre.toString().split('.').last.capitalize!,
                      style: darkTextTheme().headlineLarge,
                    ),
                    Text(
                      "Music Genre",
                      style: darkTextTheme().headlineSmall,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.shuffle,
                      size: 28,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Icon(
                      CupertinoIcons.play_circle_fill,
                      size: 28,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              // AppIconButton(
              //   icon: Icons.chevron_left,
              //   onPressed: () => _onBackButtonPressed(context),
              // ),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         selectedGenre.toString().split('.').last.capitalize!,
              //         style: const TextStyle(
              //           fontSize: 32,
              //         ),
              //       ),
              //       const Text(
              //         "Music Genre",
              //         style: TextStyle(
              //           fontSize: 16,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassContainer(
                    blur: 4,
                    color: Colors.white.withOpacity(0.25),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: _getSongs(context, selectedGenre!),
                      ),
                    ),
                  ),
                ),
              ),
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

  void _onBackButtonPressed(BuildContext context) {
    sl<NavigationController>().setTherapyTab(TabTherapyEnum.music);
  }

  List<Widget> _getSongs(BuildContext context, Genre selectedGenre) {
    return SongProvider.songs
        .where((song) => song.genre == selectedGenre)
        .map((song) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SongCard(
          song: song,
          onTap: () => _onSongTapped(context, song),
        ),
      );
    }).toList();
  }

  void _onSongTapped(BuildContext context, Song song) {
    MusicTherapy mtType = sl<SongController>().currentMTType;
    sl<SongController>().setSong(song);
    sl<SongController>().setCurrentDuration(0);

    if (mtType == MusicTherapy.basic) {
      Navigator.pushReplacementNamed(context, '/PlayGame');
    } else if (mtType == MusicTherapy.intermediate) {
      Navigator.pushReplacementNamed(context, '/VisualizerScreen');
    }
  }
}
