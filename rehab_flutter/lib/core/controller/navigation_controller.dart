import 'package:get/get.dart';
import 'package:rehab_flutter/core/enums/genre_enum.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';

class NavigationController extends GetxController {
  Rx<TabEnum> currentTab = Rx<TabEnum>(TabEnum.home);
  Rx<TabTherapyEnum> currentTherapyTab = Rx<TabTherapyEnum>(TabTherapyEnum.home);
  Rx<Genre?> selectedGenre = Rx<Genre?>(null);

  TabEnum getTab() {
    return currentTab.value;
  }

  TabTherapyEnum getTherapyTab() {
    return currentTherapyTab.value;
  }

  Genre? getSelectedGenre() {
    return selectedGenre.value;
  }

  void setTab(TabEnum newTab) {
    currentTab.value = newTab;
  }

  void setTherapyTab(TabTherapyEnum newTherapyTab) {
    currentTherapyTab.value = newTherapyTab;
  }

  void setSelectedGenre(Genre? newGenre) {
    selectedGenre.value = newGenre;
  }
}
