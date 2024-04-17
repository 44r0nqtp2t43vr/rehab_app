import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/physician.dart';

class PhysicianListCard extends StatelessWidget {
  final Physician physician;

  const PhysicianListCard({super.key, required this.physician});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                child: physician.imageURL != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: physician.imageURL!,
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
                      "${physician.firstName.capitalize!} ${physician.lastName.capitalize!}",
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
                      physician.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: darkTextTheme().headlineSmall,
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
}
