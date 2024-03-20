import 'package:get/get.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';

class SongController extends GetxController {
  late MusicTherapy currentMTType;
  Rx<double> currentDuration = 0.0.obs;
  Rx<Song?> currentSong = Rx<Song?>(null);

  double getCurrentDuration() {
    return currentDuration.value;
  }

  Song? getCurrentSong() {
    return currentSong.value;
  }

  void setMTType(MusicTherapy newMTType) {
    currentMTType = newMTType;
  }

  void setCurrentDuration(double newDuration) {
    currentDuration.value = newDuration;
  }

  void setSong(Song? newSong) {
    currentSong.value = newSong;
  }
}
