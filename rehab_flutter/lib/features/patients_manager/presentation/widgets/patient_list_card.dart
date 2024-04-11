import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class PatientListCard extends StatelessWidget {
  final AppUser patient;

  const PatientListCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final Plan? currentPlan = patient.getCurrentPlan();
    final Session? currentSession = patient.getCurrentSession();

    return GestureDetector(
      onTap: () => _onPatientCardPressed(context),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xffd1d1d1),
              radius: 32,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    CupertinoIcons.profile_circled,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${patient.firstName.capitalize!} ${patient.lastName.capitalize!}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Sailec Bold',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    patient.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: darkTextTheme().headlineSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                const Text(
                  "Daily",
                  style: TextStyle(
                    fontFamily: 'Sailec Light',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${currentSession == null ? 0 : currentSession.getSessionPercentCompletion().toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontFamily: 'Sailec Bold',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                const Text(
                  "Overall",
                  style: TextStyle(
                    fontFamily: 'Sailec Light',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${currentPlan == null ? 0 : currentPlan.getPlanPercentCompletion().toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontFamily: 'Sailec Bold',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onPatientCardPressed(BuildContext context) {
    Navigator.of(context).pushNamed("/PatientPage", arguments: patient);
  }
}
