import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';

class NavigationController extends GetxController {
  late TabEnum currentTab;
  late TabTherapyEnum currentTherapyTab;

  void setTab(TabEnum newTab) {
    currentTab = newTab;
  }

  void setTherapyTab(TabTherapyEnum newTherapyTab) {
    currentTherapyTab = newTherapyTab;
  }
}
