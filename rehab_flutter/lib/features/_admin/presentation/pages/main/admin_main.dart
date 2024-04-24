import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/patient_list/patient_list_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/dashboard/admin_dashboard.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/patients/admin_patients.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/therapists/admin_therapists.dart';
import 'package:rehab_flutter/injection_container.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  Widget getScreenFromTab(BuildContext context, TabEnum currentTab) {
    switch (currentTab) {
      case TabEnum.home:
        if (BlocProvider.of<TherapistListBloc>(context)
            .state
            .therapistList
            .isEmpty) {
          BlocProvider.of<TherapistListBloc>(context)
              .add(const FetchTherapistListEvent());
        }
        if (BlocProvider.of<PatientListBloc>(context)
            .state
            .patientList
            .isEmpty) {
          BlocProvider.of<PatientListBloc>(context)
              .add(const FetchPatientListEvent());
        }
        return const AdminDashboard();
      case TabEnum.therapists:
        return const AdminTherapists();
      case TabEnum.patients:
        return const AdminPatients();
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
    return BlocConsumer<AdminBloc, AdminState>(
      listener: (BuildContext context, AdminState state) {
        if (state is AdminNone) {
          Navigator.of(context).pushReplacementNamed("/Login");
        }
      },
      builder: (context, state) {
        // if (state is AdminLoading) {
        //   return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        // }
        if (state is AdminDone) {
          return GetX<NavigationController>(
            builder: (_) {
              final currentTab = sl<NavigationController>().getTab();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: getScreenFromTab(context, currentTab),
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
                              Expanded(
                                child: IconButton(
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  icon: Icon(
                                    currentTab == TabEnum.home
                                        ? CupertinoIcons.house_fill
                                        : CupertinoIcons.house,
                                    size: 30,
                                    color: currentTab == TabEnum.home
                                        ? Colors.white
                                        : const Color(0XFF93aac9),
                                  ),
                                  onPressed: () =>
                                      _onHomeButtonPressed(currentTab),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  icon: Icon(
                                    currentTab == TabEnum.therapists
                                        ? CupertinoIcons.person_fill
                                        : CupertinoIcons.person,
                                    size: 30,
                                    color: currentTab == TabEnum.therapists
                                        ? Colors.white
                                        : const Color(0XFF93aac9),
                                  ),
                                  onPressed: () =>
                                      _onTherapistsButtonPressed(currentTab),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  highlightColor: Colors.white.withOpacity(0.1),
                                  icon: Icon(
                                    currentTab == TabEnum.patients
                                        ? CupertinoIcons.person_fill
                                        : CupertinoIcons.person,
                                    size: 30,
                                    color: currentTab == TabEnum.patients
                                        ? Colors.white
                                        : const Color(0XFF93aac9),
                                  ),
                                  onPressed: () =>
                                      _onPatientsButtonPressed(currentTab),
                                ),
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

  void _onTherapistsButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.therapists) {
      sl<NavigationController>().setTab(TabEnum.therapists);
    }
  }

  void _onPatientsButtonPressed(TabEnum currentTab) {
    if (currentTab != TabEnum.patients) {
      sl<NavigationController>().setTab(TabEnum.patients);
    }
  }
}
