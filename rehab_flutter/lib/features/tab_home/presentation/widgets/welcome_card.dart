import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';

class WelcomeCard extends StatelessWidget {
  final String userFirstName;
  final String? userProfilePicture;

  const WelcomeCard({
    super.key,
    required this.userFirstName,
    this.userProfilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${userFirstName.capitalize}",
                  style: darkTextTheme().headlineLarge,
                ),
                Text(
                  "Welcome to cu.touch",
                  style: darkTextTheme().headlineSmall,
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: const Color(0xffd1d1d1),
            radius: 32,
            child: userProfilePicture != null
                ? Image.asset(userProfilePicture!)
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
        ],
      ),
    );
  }
}
