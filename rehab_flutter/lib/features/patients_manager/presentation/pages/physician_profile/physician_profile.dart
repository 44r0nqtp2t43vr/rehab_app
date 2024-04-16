import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_event.dart';
import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/features/tab_profile/presentation/widgets/profile_button.dart';

class PhysicianProfile extends StatelessWidget {
  final Physician physician;

  const PhysicianProfile({super.key, required this.physician});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),

      child: SafeArea(
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
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 34,
                  child: physician.imageURL != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: physician.imageURL!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          //   Image.network(
                          //   physician.imageURL!,
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
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        physician.getUserFullName(),
                        style: const TextStyle(
                          fontFamily: 'Sailec Bold',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        physician.email,
                        style: darkTextTheme().headlineSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onEditProfileButtonPressed(context),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff128BED)),
                      elevation: MaterialStateProperty.all<double>(0),
                      shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text("Edit Profile"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GlassContainer(
              shadowStrength: 2,
              shadowColor: Colors.black,
              blur: 4,
              color: Colors.white.withOpacity(0.25),
              child: Padding(
                padding: const EdgeInsets.all(24),
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
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 34,
                    child: physician.imageURL != null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: physician.imageURL!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            //   Image.network(
                            //   physician.imageURL!,
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
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${physician.firstName.capitalize!} ${physician.lastName.capitalize!}",
                          style: const TextStyle(
                            fontFamily: 'Sailec Bold',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          physician.email,
                          style: darkTextTheme().headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _onEditProfileButtonPressed(context),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        ),

                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff128BED)),

                        elevation: MaterialStateProperty.all<double>(0),
                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text("Edit Profile"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GlassContainer(
                shadowStrength: 2,
                shadowColor: Colors.black,
                blur: 4,
                color: Colors.white.withOpacity(0.25),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileButton(
                        onTap: () => _onAssignPatientsButtonPressed(context),
                        icon: CupertinoIcons.person_fill,
                        text: "Assign Patients",
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
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF128BED),
                            Color(0xFF01FF99),
                          ],
                          stops: [0.3, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 10,
                            blurRadius: 20,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _onLogoutButtonPressed(context),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          elevation: MaterialStateProperty.all<double>(0),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text("Logout"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEditProfileButtonPressed(BuildContext context) {
    Navigator.of(context).pushNamed("/EditPhysicianProfile", arguments: physician);
  }

  void _onAssignPatientsButtonPressed(BuildContext context) {
    Navigator.of(context).pushNamed("/AssignPatients");
  }

  void _onLogoutButtonPressed(BuildContext context) {
    BlocProvider.of<PhysicianBloc>(context).add(LogoutPhysicianEvent(physician));
  }
}
