import 'package:flutter/material.dart';
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
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
                        plan: plans[index],
                        planNo: index + 1,
                        isCurrent: currentPlan != null && plans[index].planId == currentPlan.planId,
                      ),
                    );
                  },
                )
              : currentPlan == null
                  ? const Text(
                      "This patient has no current plans",
                      style: TextStyle(color: Colors.white),
                    )
                  : PatientPlanItem(
                      plan: currentPlan,
                      planNo: widget.patient.plans.indexWhere((plan) => plan.startDate.month == currentPlan.startDate.month && plan.startDate.day == currentPlan.startDate.day && plan.startDate.year == currentPlan.startDate.year) + 1,
                      isCurrent: true,
                    ),
          GestureDetector(
            onTap: () => setState(() {
              showAll = !showAll;
            }),
            child: SizedBox(
              height: 32,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    showAll ? "Hide Past Plans" : "Show All Plans",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Icon(showAll ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
