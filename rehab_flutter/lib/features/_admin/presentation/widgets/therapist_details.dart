import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';

class TherapistDetails extends StatelessWidget {
  final Therapist therapist;

  const TherapistDetails({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "License Number: ${therapist.licenseNumber}",
            style: darkTextTheme().headlineSmall,
          ),
          Text(
            "Birthdate: ${DateFormat('MMMM dd, yyyy').format(therapist.birthDate)}",
            style: darkTextTheme().headlineSmall,
          ),
          Text(
            "Phone Number: ${therapist.phoneNumber}",
            style: darkTextTheme().headlineSmall,
          ),
          Text(
            "City: ${therapist.city.capitalize}",
            style: darkTextTheme().headlineSmall,
          ),
          Text(
            "Gender: ${therapist.gender}",
            style: darkTextTheme().headlineSmall,
          ),
        ],
      ),
    );
  }
}
