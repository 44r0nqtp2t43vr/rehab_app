import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class ProfileInfoCard extends StatelessWidget {
  final AppUser user;

  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 34,
          // You can add an image here using backgroundImage property
          // For example:
          // backgroundImage: AssetImage('assets/avatar_image.png'),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.firstName.capitalize!} ${user.lastName.capitalize!}",
                style: const TextStyle(
                  fontFamily: 'Sailec Bold',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                user.email,
                style: darkTextTheme().headlineSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
