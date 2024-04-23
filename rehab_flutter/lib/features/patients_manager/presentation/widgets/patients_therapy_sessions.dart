import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_session_details.dart';

class PatientstherapySessions extends StatelessWidget {
  final Plan plan;
  final int i;

  const PatientstherapySessions(
      {super.key, required this.plan, required this.i});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _showContentDialog(
        context,
        plan,
        i,
        "Session ${i + 1}",
      ),
      child: GlassContainer(
        shadowStrength: 1,
        shadowColor: Colors.black,
        blur: 4,
        color: Colors.white.withOpacity(0.25),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Session ${i + 1}',
                style: darkTextTheme().headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                DateFormat('MMMM dd, yyyy').format(plan.sessions[i].date),
                style: darkTextTheme().headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${plan.sessions[i].getSessionPercentCompletion()}%',
                style: darkTextTheme().headlineSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showContentDialog(BuildContext context, Plan plan, int i, String title) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        content: PatientstherapySessionDetails(plan: plan, i: i, title: title),
      );
    },
  );
}
