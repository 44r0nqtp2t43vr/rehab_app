import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/data_sources/song_provider.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/features/visualizer_therapy_slider/presentation/screens/visualizer_screen.dart';

// Assuming SongProvider is accessible
SongProvider songProvider = SongProvider();

class SongsListScreen extends StatelessWidget {
  const SongsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Song'),
      ),
      body: ListView.builder(
        itemCount: songProvider.songs.length,
        itemBuilder: (context, index) {
          Song song = songProvider.songs[index];
          return ListTile(
            title: Text(song.title),
            onTap: () {
              // Navigate to VisualizerSlider with the selected song
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisualizerScreenSlider(
                    songData: song,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
