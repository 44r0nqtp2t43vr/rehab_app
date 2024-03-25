import 'package:flutter/material.dart';
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
      child: Column(
        children: _getSongs(context),
      ),
    );
  }

  List<Widget> _getSongs(BuildContext context) {
    return SongProvider.songs.map((song) {
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
