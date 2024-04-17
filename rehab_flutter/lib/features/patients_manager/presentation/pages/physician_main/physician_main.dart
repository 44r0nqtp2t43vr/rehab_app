import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/physician_dashboard/physician_dashboard.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/physician_patients/physician_patients.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/pages/physician_profile/physician_profile.dart';
import 'package:rehab_flutter/injection_container.dart';

class PhysicianMainScreen extends StatelessWidget {
  const PhysicianMainScreen({super.key});

  Widget getScreenFromTab(TabEnum currentTab, Physician currentPhysician) {
    switch (currentTab) {
      case TabEnum.home:
        return const PhysicianDashboard();
      case TabEnum.patients:
        return PhysicianPatients(patients: currentPhysician.patients);
      case TabEnum.profile:
        return PhysicianProfile(physician: currentPhysician);
      default:
        return const PhysicianDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<PhysicianBloc, PhysicianState>(
      listener: (BuildContext context, PhysicianState state) {
        if (state is PhysicianNone) {
          Navigator.of(context).pushReplacementNamed("/Login");
        }
      },
      builder: (context, state) {
        if (state is PhysicianLoading) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        }
        if (state is PhysicianDone) {
          return GetX<NavigationController>(
            builder: (_) {
              final currentTab = sl<NavigationController>().getTab();

              return Column(
                children: [
                  Expanded(
                    child: getScreenFromTab(currentTab, state.currentPhysician!),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  currentTab == TabEnum.home ? CupertinoIcons.house_fill : CupertinoIcons.house,
                                  size: 30,
                                  color: currentTab == TabEnum.home ? Colors.white : const Color(0XFF93aac9),
                                ),
                                onPressed: () => _onHomeButtonPressed(currentTab),
                              ),
                              IconButton(
                                icon: Icon(
                                  CupertinoIcons.calendar,
                                  size: 30,
                                  color: currentTab == TabEnum.patients ? Colors.white : const Color(0XFF93aac9),
                                ),
                                onPressed: () => _onActivityButtonPressed(currentTab),
                              ),
                              IconButton(
                                icon: Icon(
                                  currentTab == TabEnum.profile ? CupertinoIcons.person_fill : CupertinoIcons.person,
                                  size: 30,
                                  color: currentTab == TabEnum.profile ? Colors.white : const Color(0XFF93aac9),
                                ),
                                onPressed: () => _onProfileButtonPressed(currentTab),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
        return Container();
      },
    );
  }

  void _onHomeButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.home) {
      sl<NavigationController>().setTab(TabEnum.home);
    }
  }

  void _onActivityButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.patients) {
      sl<NavigationController>().setTab(TabEnum.patients);
    }
  }

  void _onProfileButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.profile) {
      sl<NavigationController>().setTab(TabEnum.profile);
    }
  }
}
