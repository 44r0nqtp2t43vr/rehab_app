import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/core/widgets/app_iconbutton.dart';
import 'package:rehab_flutter/injection_container.dart';

class HoverSongCard extends GetView<SongController> {
  const HoverSongCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.currentSong.value != null
          ? Container(
              height: 60,
              color: Colors.blue,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.currentSong.value!.title,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          controller.currentSong.value!.artist,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppIconButton(
                    icon: Icons.play_arrow,
                    onPressed: () => _onPlayButtonPressed(context),
                  ),
                  AppIconButton(
                    icon: Icons.arrow_forward,
                    onPressed: () {},
                  ),
                  AppIconButton(
                    icon: Icons.playlist_play,
                    onPressed: () {},
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  void _onPlayButtonPressed(BuildContext context) {
    MusicTherapy mtType = sl<SongController>().currentMTType;

    if (mtType == MusicTherapy.basic) {
      Navigator.pushNamed(context, '/PlayGame');
    } else if (mtType == MusicTherapy.intermediate) {
      Navigator.pushNamed(context, '/VisualizerSlider');
    }
  }
}
