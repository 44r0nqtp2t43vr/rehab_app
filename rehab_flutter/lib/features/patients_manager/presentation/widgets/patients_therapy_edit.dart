import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/patients_therapy_edit_dialog.dart';

class PatientsTherapyEdit extends StatelessWidget {
  final Plan plan;
  final int i;

  const PatientsTherapyEdit({super.key, required this.plan, required this.i});

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
        shadowStrength: 2,
        shadowColor: Colors.black,
        blur: 4,
        color: Colors.white.withOpacity(0.25),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            CupertinoIcons.pencil,
            color: Colors.white,
            size: 26,
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
        content: PatientstherapyEditDialog(plan: plan, i: i, title: title),
      );
    },
  );
}
