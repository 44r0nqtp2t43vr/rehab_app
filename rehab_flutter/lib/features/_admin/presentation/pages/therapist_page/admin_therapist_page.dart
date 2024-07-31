import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/therapist_list/therapist_list_event.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_therapist/viewed_therapist_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_therapist/viewed_therapist_state.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/therapist_details.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/therapist_details_patients.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/therapist_profile_info_card.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patient_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/therapist_patients_list/therapist_patients_list_event.dart';

class AdminTherapistPage extends StatelessWidget {
  const AdminTherapistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ViewedTherapistBloc, ViewedTherapistState>(
          listenWhen: (previous, current) => previous is ViewedTherapistLoading && current is ViewedTherapistDone,
          listener: (context, state) {
            if (state is ViewedTherapistDone) {
              BlocProvider.of<TherapistListBloc>(context).add(UpdateTherapistListEvent(state.therapist!));
              BlocProvider.of<TherapistPatientListBloc>(context).add(FetchTherapistPatientListEvent(state.therapist!.therapistId));
            }
          },
          builder: (context, state) {
            if (state is ViewedTherapistLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/lotties/uploading.json',
                  width: 400,
                  height: 400,
                ),
              );
            }
            if (state is ViewedTherapistDone) {
              final currentTherapist = state.therapist!;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              size: 35,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Expanded(
                            child: TherapistProfileInfoCard(therapist: currentTherapist),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Therapist Details",
                          style: darkTextTheme().displaySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TherapistDetails(therapist: currentTherapist),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Patients",
                          style: darkTextTheme().displaySmall,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TherapistDetailsPatients(therapist: currentTherapist),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
