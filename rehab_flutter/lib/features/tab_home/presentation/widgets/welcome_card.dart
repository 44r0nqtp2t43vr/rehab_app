import 'package:cached_network_image/cached_network_image.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 12),
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
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userProfilePicture!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    // Image.network(
                    //   userProfilePicture!,
                    //   fit: BoxFit.cover,
                    //   width: double.infinity,
                    //   height: double.infinity,
                    // ),
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
        ],
      ),
    );
  }
}
