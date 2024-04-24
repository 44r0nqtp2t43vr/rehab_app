import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_plan_item.dart';

class PatientPlansList extends StatefulWidget {
  final AppUser patient;

  const PatientPlansList({super.key, required this.patient});

  @override
  State<PatientPlansList> createState() => _PatientPlansListState();
}

class _PatientPlansListState extends State<PatientPlansList> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final plans = widget.patient.plans;
    final currentPlan = widget.patient.getCurrentPlan();

    return GlassContainer(
      shadowStrength: 2,
      shadowColor: Colors.black,
      blur: 4,
      color: Colors.white.withOpacity(0.25),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showAll
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: index + 1 == plans.length ? const EdgeInsets.all(0) : const EdgeInsets.only(bottom: 12.0),
                        child: PatientPlanItem(
                          onPressedRoute: '/PatientPlanDetails',
                          patientPlan: PatientPlan(patientId: widget.patient.userId, plan: plans[index]),
                          planNo: index + 1,
                          isCurrent: currentPlan != null && plans[index].planId == currentPlan.planId,
                        ),
                      );
                    },
                  )
                : currentPlan == null
                    ? Text(
                        "This patient has no current plans.",
                        style: darkTextTheme().headlineSmall,
                      )
                    : PatientPlanItem(
                        onPressedRoute: '/PatientPlanDetails',
                        patientPlan: PatientPlan(patientId: widget.patient.userId, plan: currentPlan),
                        planNo: widget.patient.plans.indexWhere((plan) => plan.startDate.month == currentPlan.startDate.month && plan.startDate.day == currentPlan.startDate.day && plan.startDate.year == currentPlan.startDate.year) + 1,
                        isCurrent: true,
                      ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => setState(() {
                    showAll = !showAll;
                  }),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 32,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    showAll ? "Hide Past Plans" : "Show All Plans",
                                    style: darkTextTheme().headlineSmall,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Icon(showAll ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
