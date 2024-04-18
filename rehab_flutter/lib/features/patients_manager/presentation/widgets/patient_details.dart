import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class PatientDetails extends StatelessWidget {
  final AppUser patient;

  const PatientDetails({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Birthdate: ${DateFormat('MMMM dd, yyyy').format(patient.birthDate)}",
            style: darkTextTheme().headlineSmall,
          ),
          Text(
            "Phone Number: ${patient.phoneNumber}",
            style: darkTextTheme().headlineSmall,
          ),
          Text(
            "City: ${patient.city.capitalize}",
            style: darkTextTheme().headlineSmall,
          ),
          Text(
            "Gender: ${patient.gender}",
            style: darkTextTheme().headlineSmall,
          ),
        ],
      ),
    );
  }
}
