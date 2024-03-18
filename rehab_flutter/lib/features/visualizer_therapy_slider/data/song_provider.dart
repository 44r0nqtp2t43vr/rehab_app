import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/song_model.dart';

class SongProvider {
  List<Song> songs = [
    Song(
      name: "Forest of Blocks",
      audioUrl: "audio/forestofblocks.mp3",
      metaDataUrl: "assets/data/forestofblocks.json",
    ),
    Song(
      name: "ExB",
      audioUrl: "audio/ExB.mp3",
      metaDataUrl: "assets/data/ExB.json",
    ),
    Song(
        name: "Can Can",
        metaDataUrl: "assets/data/cancan.json",
        audioUrl: "audio/cancan.mp3"),
    Song(
        name: "Canon in D",
        metaDataUrl: "assets/data/canon.json",
        audioUrl: "audio/canon.mp3"),
    Song(
        name: "Viva La Vida",
        audioUrl: "audio/vivalavida.mp3",
        metaDataUrl: 'assets/data/vivalavida.json')
  ];
}
