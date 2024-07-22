import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/patient_sorting_type.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient_plan_sessions_list/viewed_therapist_patient_plan_sessions_list_state.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_completion_rate.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_plan_details.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_plan_session_item.dart';

class PatientPlanDetails extends StatefulWidget {
  final PatientPlan patientPlan;

  const PatientPlanDetails({super.key, required this.patientPlan});

  @override
  State<PatientPlanDetails> createState() => _PatientPlanDetailsState();
}

class _PatientPlanDetailsState extends State<PatientPlanDetails> {
  final List<String> availableTypes = availableSortingTypes;
  late List<AppUser> sortedPatients;
  late String currentType;

  @override
  void initState() {
    currentType = availableSortingTypes[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.patientPlan.plan.planName
                                    .replaceFirstMapped(
                                      RegExp(r'^plan'),
                                      (match) => 'Plan',
                                    )
                                    .replaceAllMapped(
                                      RegExp(r'(\d+)'),
                                      (match) => ' ${match.group(0)}',
                                    ),
                                style: darkTextTheme().headlineLarge,
                              ),
                              Text(
                                "Therapy Plan Details",
                                style: darkTextTheme().headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              widget.patientPlan.plan.isBlank!
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              PatientsTherapyCompletionRate(plan: widget.patientPlan.plan),
                              const SizedBox(width: 16),
                              PatientsTherapyPlanDetails(patientPlan: widget.patientPlan),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Sessions",
                                        style: darkTextTheme().displaySmall,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    BlocBuilder<ViewedTherapistPatientPlanSessionsListBloc, ViewedTherapistPatientPlanSessionsListState>(
                                      builder: (context, state) {
                                        if (state is ViewedTherapistPatientPlanSessionsListLoading) {
                                          return const Center(
                                            child: CupertinoActivityIndicator(color: Colors.white),
                                          );
                                        }
                                        if (state is ViewedTherapistPatientPlanSessionsListDone) {
                                          final sessionsList = state.sessionsList;

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: sessionsList.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 16.0),
                                                child: PatientPlanSessionItem(
                                                  patientPlan: widget.patientPlan,
                                                  session: sessionsList[index],
                                                  index: index,
                                                ),
                                              );
                                            },
                                          );
                                        }

                                        return const SizedBox();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
