import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/song.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final Function() onTap;

  const SongCard({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: const Icon(
            CupertinoIcons.play_rectangle_fill,
            size: 36,
            color: Colors.white,
          ),
          title: Text(
            song.title,
            style: const TextStyle(
              fontFamily: 'Sailec Medium',
              fontSize: 14,
              height: 1.2,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            song.artist,
            style: const TextStyle(
              fontFamily: 'Sailec Light',
              fontSize: 12,
              height: 1.2,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              song.songTime,
              style: darkTextTheme().displaySmall,
            ),
          ),
        ),
      ),
    );
  }
}
