import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/dashboard/admin_dashboard.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/patients/admin_patients.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/physicians/admin_physicians.dart';
import 'package:rehab_flutter/injection_container.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  Widget getScreenFromTab(TabEnum currentTab, Admin currentAdmin) {
    switch (currentTab) {
      case TabEnum.home:
        return AdminDashboard(currentAdmin: currentAdmin);
      case TabEnum.physicians:
        return AdminPhysicians(currentAdmin: currentAdmin);
      case TabEnum.patients:
        return AdminPatients(currentAdmin: currentAdmin);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        }
        if (state is AdminDone) {
          return GetX<NavigationController>(
            builder: (_) {
              final currentTab = sl<NavigationController>().getTab();

              return Column(
                children: [
                  Expanded(
                    child: getScreenFromTab(currentTab, state.currentAdmin!),
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
                                  currentTab == TabEnum.physicians ? CupertinoIcons.person_fill : CupertinoIcons.person,
                                  size: 30,
                                  color: currentTab == TabEnum.physicians ? Colors.white : const Color(0XFF93aac9),
                                ),
                                onPressed: () => _onPhysiciansButtonPressed(currentTab),
                              ),
                              IconButton(
                                icon: Icon(
                                  currentTab == TabEnum.patients ? CupertinoIcons.person_fill : CupertinoIcons.person,
                                  size: 30,
                                  color: currentTab == TabEnum.patients ? Colors.white : const Color(0XFF93aac9),
                                ),
                                onPressed: () => _onPatientsButtonPressed(currentTab),
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
        return const SizedBox();
      },
    );
  }

  void _onHomeButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.home) {
      sl<NavigationController>().setTab(TabEnum.home);
    }
  }

  void _onPhysiciansButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.physicians) {
      sl<NavigationController>().setTab(TabEnum.physicians);
    }
  }

  void _onPatientsButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.patients) {
      sl<NavigationController>().setTab(TabEnum.patients);
    }
  }
}
