import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/tab_activity_monitor/presentation/pages/activity_monitor/activity_monitor.dart';
import 'package:rehab_flutter/features/tab_home/presentation/pages/home/home_screen.dart';
import 'package:rehab_flutter/features/tab_therapy/presentation/pages/therapy/therapy_screen.dart';
import 'package:rehab_flutter/injection_container.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Widget getScreenFromTab(TabEnum currentTab) {
    switch (currentTab) {
      case TabEnum.home:
        return const HomeScreen();
      case TabEnum.therapy:
        return const TherapyScreen();
      case TabEnum.activityMonitor:
      // return const ActivityMonitor();
      case TabEnum.profile:
        return const HomeScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<NavigationController>(
      builder: (_) {
        final currentTab = sl<NavigationController>().getTab();
        final currentTabTherapy = sl<NavigationController>().getTherapyTab();

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }

            if (currentTab == TabEnum.therapy &&
                currentTabTherapy == TabTherapyEnum.music) {
              sl<NavigationController>().setTherapyTab(TabTherapyEnum.home);
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: getScreenFromTab(currentTab),
                  ),
                  Row(
                    children: [
                      AppButton(
                        onPressed: () => _onHomeButtonPressed(currentTab),
                        child: const Text('Home'),
                      ),
                      AppButton(
                        onPressed: () => _onTherapyButtonPressed(currentTab),
                        child: const Text('Therapy'),
                      ),
                      AppButton(
                        onPressed: () => _onActivityButtonPressed(currentTab),
                        child: const Text('Activity'),
                      ),
                      AppButton(
                        onPressed: () => _onProfileButtonPressed(currentTab),
                        child: const Text('Profile'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onHomeButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.home) {
      sl<NavigationController>().setTab(TabEnum.home);
    }
  }

  void _onTherapyButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.therapy) {
      sl<NavigationController>().setTab(TabEnum.therapy);
      sl<NavigationController>().setTherapyTab(TabTherapyEnum.home);
    }
  }

  void _onActivityButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.activityMonitor) {
      sl<NavigationController>().setTab(TabEnum.activityMonitor);
    }
  }

  void _onProfileButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.profile) {
      sl<NavigationController>().setTab(TabEnum.profile);
    }
  }
}
