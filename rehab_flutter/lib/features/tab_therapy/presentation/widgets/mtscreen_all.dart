import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/data_sources/song_provider.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/widgets/song_card.dart';

class MTScreenAll extends StatelessWidget {
  final Function(BuildContext, Song) callback;

  const MTScreenAll({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _getSongs(context),
      ),
    );
  }

  List<Widget> _getSongs(BuildContext context) {
    SongProvider songProvider = SongProvider();

    return songProvider.songs.map((song) {
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
    callback(context, song);
  }
}
