import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/admin/admin_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/admin_patient_numbers/admin_patient_numbers_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/admin_patient_numbers/admin_patient_numbers_state.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/therapists_numbers.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_numbers.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/welcome_card.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Column(
            children: [
              const WelcomeCard(userFirstName: "Admin"),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Therapist Statistics",
                  style: darkTextTheme().displaySmall,
                ),
              ),
              const SizedBox(height: 8),
              const TherapistsNumbers(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Patient Statistics",
                  style: darkTextTheme().displaySmall,
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<AdminPatientNumbersBloc, AdminPatientNumbersState>(
                builder: (context, state) {
                  if (state is AdminPatientNumbersLoading) {
                    return const Center(child: CupertinoActivityIndicator(color: Colors.white));
                  }
                  if (state is AdminPatientNumbersDone) {
                    return PatientsNumbers(patientNumbers: state.patientNumbers);
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF128BED),
                            Color(0xFF01FF99),
                          ],
                          stops: [0.3, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 10,
                            blurRadius: 20,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _onLogoutButtonPressed(context),
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
                          elevation: WidgetStateProperty.all<double>(0),
                          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                          overlayColor: WidgetStateProperty.all<Color>(
                            Colors.white.withOpacity(0.2),
                          ),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text("Logout"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogoutButtonPressed(BuildContext context) {
    BlocProvider.of<AdminBloc>(context).add(LogoutAdminEvent());
  }
}
