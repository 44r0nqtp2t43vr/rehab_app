import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class PatientDetails extends StatelessWidget {
  final AppUser patient;

  const PatientDetails({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Birthdate: ${DateFormat('MMMM dd, yyyy').format(patient.birthDate)}",
          style: darkTextTheme().headlineSmall,
        ),
      ],
    );
  }
}
