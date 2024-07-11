import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_plan_item.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/select_plan_dialog.dart';

class PatientPlansList extends StatefulWidget {
  final AppUser patient;
  final List<Plan> plansList;

  const PatientPlansList({super.key, required this.patient, required this.plansList});

  @override
  State<PatientPlansList> createState() => _PatientPlansListState();
}

class _PatientPlansListState extends State<PatientPlansList> {
  bool showAll = false;

  Plan? getCurrentPlan() {
    final DateTime today = DateTime.now();
    final Plan currentPlan = widget.plansList.lastWhere(
      (plan) => DateTime(plan.endDate.year, plan.endDate.month, plan.endDate.day).isAfter(today),
      orElse: () => Plan.empty(),
    );
    return currentPlan.planId.isEmpty ? null : currentPlan;
  }

  @override
  Widget build(BuildContext context) {
    final plans = widget.plansList;
    final currentPlan = getCurrentPlan();

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
                          patientPlan: PatientPlan(patient: widget.patient, plan: plans[index]),
                          planNo: index + 1,
                          isCurrent: currentPlan != null && plans[index].planId == currentPlan.planId,
                        ),
                      );
                    },
                  )
                : currentPlan == null
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "This patient has no current plans.",
                                  style: darkTextTheme().headlineSmall,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _onAddPlanButtonPressed(context, widget.patient),
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff128BED)),
                                    elevation: MaterialStateProperty.all<double>(0),
                                    shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                    overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.2)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: const Text("Add Plan"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : PatientPlanItem(
                        onPressedRoute: '/PatientPlanDetails',
                        patientPlan: PatientPlan(patient: widget.patient, plan: currentPlan),
                        planNo: widget.plansList.indexWhere((plan) => plan.startDate.month == currentPlan.startDate.month && plan.startDate.day == currentPlan.startDate.day && plan.startDate.year == currentPlan.startDate.year) + 1,
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

  void _onAddPlanButtonPressed(BuildContext context, AppUser patient) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          content: SelectPlanDialog(patient: patient),
        );
      },
    );
  }
}
