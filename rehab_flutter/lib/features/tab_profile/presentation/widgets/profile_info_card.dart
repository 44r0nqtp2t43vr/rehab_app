import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class ProfileInfoCard extends StatelessWidget {
  final AppUser user;

  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 34,
          child: user.imageURL != null
              ? ClipOval(
                  child: Image.network(
                  '${user.imageURL!}&cache=${DateTime.now().millisecondsSinceEpoch}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ))
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
                user.getUserFullName(),
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
