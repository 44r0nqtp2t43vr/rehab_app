import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/patient_sorting_type.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_completion_rate.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_edit.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_plan_details.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_sessions.dart';

class PatientPlanDetails extends StatefulWidget {
  final Plan plan;

  const PatientPlanDetails({super.key, required this.plan});

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
                                widget.plan.planName
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
              widget.plan.isBlank!
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              PatientsTherapyCompletionRate(plan: widget.plan),
                              const SizedBox(width: 16),
                              PatientsTherapyPlanDetails(plan: widget.plan),
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
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0;
                                            i < widget.plan.sessions.length;
                                            i++)
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        PatientstherapySessions(
                                                      plan: widget.plan,
                                                      i: i,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  PatientsTherapyEdit(
                                                    plan: widget.plan,
                                                    i: i,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                            ],
                                          ),
                                      ],
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
