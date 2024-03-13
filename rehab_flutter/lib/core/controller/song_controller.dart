import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rehab_flutter/core/enums/song_enums.dart';

class SongController extends GetxController {
  late MusicTherapy currentMTType;

  void setMTType(MusicTherapy newMTType) {
    currentMTType = newMTType;
  }
}
