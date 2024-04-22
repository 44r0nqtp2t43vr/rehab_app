import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/patient_sorting_type.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
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
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GlassContainer(
                                  shadowStrength: 2,
                                  shadowColor: Colors.black,
                                  blur: 4,
                                  color: Colors.white.withOpacity(0.25),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 24,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircularPercentIndicator(
                                          radius: 0.4 * 136,
                                          lineWidth: 10.0,
                                          percent: widget.plan
                                                  .getPlanPercentCompletion() /
                                              100,
                                          center: Text(
                                            "${widget.plan.getPlanPercentCompletion().toStringAsFixed(2)}%",
                                            style: const TextStyle(
                                              fontFamily: "Sailec Bold",
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          backgroundColor: Colors.white,
                                          progressColor:
                                              const Color(0xff01FF99),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Therapy Plan Completion Rate",
                                          style: darkTextTheme().headlineSmall,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text(
                                          //   "Plan Details",
                                          //   style: darkTextTheme().displaySmall,
                                          // ),
                                          // const SizedBox(height: 16),
                                          Text(
                                            "Plan No.:",
                                            style:
                                                darkTextTheme().headlineSmall,
                                          ),
                                          Text(
                                            widget.plan.planName
                                                .replaceAllMapped(
                                              RegExp(r'\D+'),
                                              (match) => '',
                                            ),
                                            style: darkTextTheme().displaySmall,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Start Date:',
                                            style:
                                                darkTextTheme().headlineSmall,
                                          ),
                                          Text(
                                            DateFormat('MMMM dd, yyyy')
                                                .format(widget.plan.startDate),
                                            style: darkTextTheme().displaySmall,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'End Date:',
                                            style:
                                                darkTextTheme().headlineSmall,
                                          ),
                                          Text(
                                            DateFormat('MMMM dd, yyyy')
                                                .format(widget.plan.endDate),
                                            style: darkTextTheme().displaySmall,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Session Progress: ",
                                            style:
                                                darkTextTheme().headlineSmall,
                                          ),
                                          Text(
                                            " ${widget.plan.sessions.indexWhere((session) => session.date.month == DateTime.now().month && session.date.day == DateTime.now().day && session.date.year == DateTime.now().year) + 1}/${widget.plan.sessions.length}",
                                            style: darkTextTheme().displaySmall,
                                          ),
                                          const SizedBox(height: 8),
                                          // Text(
                                          //   "Active Plan:",
                                          //   style: darkTextTheme().headlineSmall,
                                          // ),
                                          // Text(
                                          //   widget.plan.isActive == false
                                          //       ? 'Yes'
                                          //       : 'No',
                                          //   style: darkTextTheme().displaySmall,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                              GlassContainer(
                                                shadowStrength: 1,
                                                shadowColor: Colors.black,
                                                blur: 4,
                                                color: Colors.white
                                                    .withOpacity(0.25),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 12,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Session ${i + 1}',
                                                        style: darkTextTheme()
                                                            .headlineSmall,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                                'MMMM dd, yyyy')
                                                            .format(widget
                                                                .plan
                                                                .sessions[i]
                                                                .date),
                                                        style: darkTextTheme()
                                                            .headlineSmall,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        '${widget.plan.sessions[i].getSessionPercentCompletion()}%',
                                                        style: darkTextTheme()
                                                            .headlineSmall,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                const SizedBox(height: 16),
                // widget.plan.isBlank!
                //     ? const Text("You have no assigned patients",
                //         style: TextStyle(color: Colors.white))
                //     : ListView.builder(
                //         shrinkWrap: true,
                //         physics: const NeverScrollableScrollPhysics(),
                //         itemCount: sortedPatients.length,
                //         itemBuilder: (context, index) {
                //           // Get the current patient
                //           final patient = sortedPatients[index];
                //           // Display the patient's ID
                //           return Padding(
                //             padding: const EdgeInsets.only(bottom: 16),
                //             child: PatientListCard(
                //               patient: patient,
                //               onPressedRoute: "/PatientPage",
                //             ),
                //           );
                //         },
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
