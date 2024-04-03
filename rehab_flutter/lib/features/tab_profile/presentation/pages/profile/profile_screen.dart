import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/tab_profile/presentation/widgets/profile_button.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: darkTextTheme().headlineLarge,
                  ),
                  Text(
                    "Account Settings",
                    style: darkTextTheme().headlineSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onEditProfileButtonPressed(context),
              child: const Text("Edit Profile"),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileButton(
                    onTap: () {},
                    icon: Icons.bluetooth,
                    text: "Connected Device",
                  ),
                  const SizedBox(height: 20),
                  ProfileButton(
                    onTap: () {},
                    icon: Icons.assignment,
                    text: "Terms of Services",
                  ),
                  const SizedBox(height: 20),
                  ProfileButton(
                    onTap: () {},
                    icon: Icons.security,
                    text: "Privacy Policy",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _onLogoutButtonPressed(context, user),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }

  void _onEditProfileButtonPressed(BuildContext context) {
    Navigator.of(context).pushNamed("/EditProfile");
  }

  void _onLogoutButtonPressed(BuildContext context, AppUser user) {
    BlocProvider.of<UserBloc>(context).add(LogoutEvent(user));
  }
}
