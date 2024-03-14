import 'package:get/get.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';

class SongController extends GetxController {
  late MusicTherapy currentMTType;
  Rx<int> currentNoteIndex = Rx<int>(0);
  Rx<Song?> currentSong = Rx<Song?>(null);

  int getCurrentNoteIndex() {
    return currentNoteIndex.value;
  }

  Song? getCurrentSong() {
    return currentSong.value;
  }

  void setMTType(MusicTherapy newMTType) {
    currentMTType = newMTType;
  }

  void setNoteIndex(int newNoteIndex) {
    currentNoteIndex.value = newNoteIndex;
  }

  void setSong(Song? newSong) {
    currentSong.value = newSong;
  }
}
