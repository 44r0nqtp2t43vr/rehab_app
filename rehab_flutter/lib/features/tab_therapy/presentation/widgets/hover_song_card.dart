import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:marquee/marquee.dart';
import 'package:rehab_flutter/core/controller/song_controller.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';
import 'package:rehab_flutter/injection_container.dart';

class HoverSongCard extends GetView<SongController> {
  const HoverSongCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.currentSong.value != null
          ? GlassContainer(
              height: 60,
              blur: 20,
              color: Colors.white.withValues(alpha: 0.35),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      CupertinoIcons.play_rectangle_fill,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 24,
                          child: Marquee(
                            text: controller.currentSong.value!.title,
                            style: const TextStyle(
                              fontFamily: 'Sailec Medium',
                              fontSize: 14,
                              height: 1.2,
                              color: Colors.white,
                            ),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 32,
                            velocity: 60.0,
                            pauseAfterRound: const Duration(seconds: 2),
                            startPadding: 5.0,
                            accelerationDuration: const Duration(seconds: 1),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: const Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                            showFadingOnlyWhenScrolling: true,
                            fadingEdgeStartFraction: 0.1,
                            fadingEdgeEndFraction: 0.1,
                          ),
                        ),
                        Text(
                          controller.currentSong.value!.artist,
                          style: const TextStyle(
                            fontFamily: 'Sailec Light',
                            fontSize: 12,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.play_arrow_solid,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () => _onPlayButtonPressed(context),
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.forward_end_fill,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.square_list_fill,
                      size: 24,
                      color: Colors.white,
                    ),
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
      Navigator.pushNamed(context, '/VisualizerScreen');
    }
  }
}
