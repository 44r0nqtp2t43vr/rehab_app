import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';

class TherapistListCard extends StatelessWidget {
  final Therapist therapist;

  const TherapistListCard({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTherapistListCardPressed(context, therapist),
      child: GlassContainer(
        shadowStrength: 2,
        shadowColor: Colors.black,
        blur: 4,
        color: Colors.white.withOpacity(0.25),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xffd1d1d1),
                radius: 32,
                child: therapist.imageURL != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: therapist.imageURL!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      )
                    : const Center(
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
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${therapist.firstName.capitalize!} ${therapist.lastName.capitalize!}",
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
                      therapist.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: darkTextTheme().headlineSmall,
                    ),
                    Text(
                      "No. of Patients: ${therapist.patients.length}",
                      style: const TextStyle(
                        fontFamily: 'Sailec Light',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTherapistListCardPressed(BuildContext context, Therapist therapist) {
    Navigator.of(context).pushNamed("/AdminTherapistPage", arguments: therapist);
  }
}
