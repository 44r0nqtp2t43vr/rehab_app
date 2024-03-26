import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeCard extends StatelessWidget {
  final String userFirstName;

  const WelcomeCard({super.key, required this.userFirstName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${userFirstName.capitalize}",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Welcome to cu.touch",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 24,
            // You can add an image here using backgroundImage property
            // For example:
            // backgroundImage: AssetImage('assets/avatar_image.png'),
          ),
        ],
      ),
    );
  }
}
