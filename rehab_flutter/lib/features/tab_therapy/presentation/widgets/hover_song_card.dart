import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/widgets/app_iconbutton.dart';

class HoverSongCard extends StatelessWidget {
  final Song song;

  const HoverSongCard({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.blue,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  song.artist,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          AppIconButton(
            icon: Icons.play_arrow,
            onPressed: () {},
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
    );
  }
}
