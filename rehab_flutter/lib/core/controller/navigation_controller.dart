import 'package:get/get.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';

class NavigationController extends GetxController {
  Rx<TabEnum> currentTab = Rx<TabEnum>(TabEnum.home);
  Rx<TabTherapyEnum> currentTherapyTab = Rx<TabTherapyEnum>(TabTherapyEnum.home);

  TabEnum getTab() {
    return currentTab.value;
  }

  TabTherapyEnum getTherapyTab() {
    return currentTherapyTab.value;
  }

  void setTab(TabEnum newTab) {
    currentTab.value = newTab;
  }

  void setTherapyTab(TabTherapyEnum newTherapyTab) {
    currentTherapyTab.value = newTherapyTab;
  }
}
