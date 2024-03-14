import 'package:get/get.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';

class SongController extends GetxController {
  late MusicTherapy currentMTType;
  Rx<int> currentNoteIndex = 0.obs;
  Rx<Song?> currentSong = null.obs;

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
