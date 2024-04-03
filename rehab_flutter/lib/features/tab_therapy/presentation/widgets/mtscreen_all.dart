import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/data_sources/song_provider.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/song_card.dart';
import 'package:rehab_flutter/injection_container.dart';

class MTScreenAll extends StatelessWidget {
  const MTScreenAll({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Songs',
                  style: darkTextTheme().displaySmall,
                ),
                const Row(
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
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            GlassContainer(
              blur: 4,
              color: Colors.white.withOpacity(0.25),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: _getSongs(context),
                ),
              ),
            ),
            GetBuilder<SongController>(
              builder: (controller) {
                if (controller.currentSong.value != null) {
                  return const SizedBox(height: 80);
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getSongs(BuildContext context) {
    return SongProvider.songs.map((song) {
      return SongCard(
        song: song,
        onTap: () => _onSongTapped(context, song),
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
