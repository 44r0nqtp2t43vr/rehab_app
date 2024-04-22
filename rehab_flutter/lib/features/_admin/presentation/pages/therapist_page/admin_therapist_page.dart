import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/therapist_details.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/therapist_details_patients.dart';
import 'package:rehab_flutter/features/_admin/presentation/widgets/therapist_profile_info_card.dart';

class AdminTherapistPage extends StatelessWidget {
  final Therapist therapist;

  const AdminTherapistPage({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
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
                      child: TherapistProfileInfoCard(therapist: therapist),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Therapist Details",
                    style: darkTextTheme().displaySmall,
                  ),
                ),
                const SizedBox(height: 8),
                TherapistDetails(therapist: therapist),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Patients",
                    style: darkTextTheme().displaySmall,
                  ),
                ),
                const SizedBox(height: 8),
                TherapistDetailsPatients(therapist: therapist),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
