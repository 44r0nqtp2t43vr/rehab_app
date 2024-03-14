import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/pages/activity_monitor/activity_monitor.dart';
import 'package:rehab_flutter/features/tab_home/presentation/pages/home/home_screen.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/pages/therapy/therapy_screen.dart';
import 'package:rehab_flutter/injection_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget getScreenFromTab() {
    switch (sl<NavigationController>().currentTab) {
      case TabEnum.home:
        return const HomeScreen();
      case TabEnum.therapy:
        return const TherapyScreen();
      case TabEnum.activityMonitor:
        return const ActivityMonitor();
      case TabEnum.profile:
        return const HomeScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        final currentTab = sl<NavigationController>().currentTab;
        final currentTabTherapy = sl<NavigationController>().currentTherapyTab;

        if (currentTab == TabEnum.therapy && currentTabTherapy == TabTherapyEnum.music) {
          sl<NavigationController>().currentTherapyTab = TabTherapyEnum.home;
          //TODO: fix navigation
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: getScreenFromTab(),
              ),
              Row(
                children: [
                  AppButton(
                    onPressed: () => _onHomeButtonPressed(),
                    child: const Text('Home'),
                  ),
                  AppButton(
                    onPressed: () => _onTherapyButtonPressed(),
                    child: const Text('Therapy'),
                  ),
                  AppButton(
                    onPressed: () => _onActivityButtonPressed(),
                    child: const Text('Activity'),
                  ),
                  AppButton(
                    onPressed: () => _onProfileButtonPressed(),
                    child: const Text('Profile'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onHomeButtonPressed() {
    if (sl<NavigationController>().currentTab != TabEnum.home) {
      sl<NavigationController>().setTab(TabEnum.home);
      setState(() {});
    }
  }

  void _onTherapyButtonPressed() {
    if (sl<NavigationController>().currentTab != TabEnum.therapy) {
      sl<NavigationController>().setTab(TabEnum.therapy);
      sl<NavigationController>().setTherapyTab(TabTherapyEnum.home);
      setState(() {});
    }
  }

  void _onActivityButtonPressed() {
    if (sl<NavigationController>().currentTab != TabEnum.activityMonitor) {
      sl<NavigationController>().setTab(TabEnum.activityMonitor);
      setState(() {});
    }
  }

  void _onProfileButtonPressed() {
    if (sl<NavigationController>().currentTab != TabEnum.profile) {
      sl<NavigationController>().setTab(TabEnum.profile);
      setState(() {});
    }
  }
}
