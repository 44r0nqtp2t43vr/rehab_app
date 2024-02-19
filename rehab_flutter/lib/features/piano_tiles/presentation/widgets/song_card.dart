import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/piano_tiles/domain/entities/song.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final Function() onTap;

  const SongCard({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(song.title),
          subtitle: Text(song.artist),
        ),
      ),
    );
  }
}
