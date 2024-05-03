import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_bloc.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/bloc/viewed_therapist_patient/viewed_therapist_patient_event.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patient_plan_item.dart';
import 'package:rehab_flutter/features/tab_home/domain/entities/add_plan_data.dart';

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
                                  onPressed: () => _onAddPlanButtonPressed(context),
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

  void _onAddPlanButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          content: GlassContainer(
            blur: 10,
            color: Colors.white.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/actuator.svg',
                        width: MediaQuery.of(context).size.width * .06,
                        height: MediaQuery.of(context).size.height * .06,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select",
                              style: TextStyle(
                                fontFamily: 'Sailec Bold',
                                fontSize: 22,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Therapy Plan",
                              style: TextStyle(
                                fontFamily: 'Sailec Light',
                                fontSize: 16,
                                height: 1.2,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  cuSelectPlanButtons(
                    context: context,
                    onPressed: () => _selectPlan(context, 'One Week', widget.patient),
                    title: 'Plan 1: One Week',
                    subtitle: '149.99 NTD',
                  ),
                  const SizedBox(height: 20),
                  cuSelectPlanButtons(
                    context: context,
                    onPressed: () => _selectPlan(context, 'One Month', widget.patient),
                    title: 'Plan 2: One Month',
                    subtitle: '499.99 NTD',
                  ),
                  const SizedBox(height: 20),
                  cuSelectPlanButtons(
                    context: context,
                    onPressed: () => _selectPlan(context, 'Three Months', widget.patient),
                    title: 'Plan 3: Three Months',
                    subtitle: '999.99 NTD',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Theme(
                        data: darkButtonTheme,
                        child: ElevatedButton(
                          onPressed: () => _onCloseButtonPressed(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectPlan(BuildContext context, String planName, AppUser user) {
    int daysToAdd;
    switch (planName) {
      case 'One Week':
        daysToAdd = 7;
        break;
      case 'One Month':
        daysToAdd = 30;
        break;
      case 'Three Months':
        daysToAdd = 90;
        break;
      default:
        daysToAdd = 7;
    }
    Navigator.of(context).pop();
    BlocProvider.of<ViewedTherapistPatientBloc>(context).add(AddPatientPlanEvent(AddPlanData(user: user, planSelected: daysToAdd)));
  }

  void _onCloseButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }
}
