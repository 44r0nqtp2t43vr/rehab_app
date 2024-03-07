import 'package:rehab_flutter/features/visualizer_therapy_slider/domain/models/Song.dart';

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
        name: "Cancan",
        metaDataUrl: "audio/cancan.mp3",
        audioUrl: "assets/data/cancan.json"),
    Song(
        name: "Canon",
        metaDataUrl: "audio/canon.mp3",
        audioUrl: "assets/data/canon.json")
  ];
}
