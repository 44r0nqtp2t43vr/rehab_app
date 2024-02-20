import 'package:flutter/material.dart';
import 'package:rehab_flutter/features/piano_tiles/data/data_sources/song_provider.dart';
import 'package:rehab_flutter/features/piano_tiles/domain/entities/song.dart';
import 'package:rehab_flutter/features/piano_tiles/presentation/widgets/song_card.dart';

class BgSongSelect extends StatelessWidget {
  const BgSongSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Song Select',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  _buildBody(BuildContext context) {
    SongProvider songProvider = SongProvider();

    return ListView.builder(
      itemCount: songProvider.songs.length,
      itemBuilder: (context, index) {
        final Song song = songProvider.songs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SongCard(
            song: song,
            onTap: () => _onSTViewTapped(context, song),
          ),
        );
      },
    );
  }

  void _onSTViewTapped(BuildContext context, Song song) {
    Navigator.pushNamed(context, '/ScrollTextures', arguments: song);
  }
}
