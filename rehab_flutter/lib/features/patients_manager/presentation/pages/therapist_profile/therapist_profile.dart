import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_event.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/features/tab_profile/presentation/widgets/profile_button.dart';

class TherapistProfile extends StatelessWidget {
  final Therapist therapist;

  const TherapistProfile({super.key, required this.therapist});

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
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 34,
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
                          //   Image.network(
                          //   therapist.imageURL!,
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
                        therapist.getUserFullName(),
                        style: const TextStyle(
                          fontFamily: 'Sailec Bold',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        therapist.email,
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
                      foregroundColor: WidgetStateProperty.all<Color>(
                        Colors.white,
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(const Color(0xff128BED)),
                      elevation: WidgetStateProperty.all<double>(0),
                      shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                      overlayColor: WidgetStateProperty.all<Color>(Colors.white.withValues(alpha: 0.2)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
              color: Colors.white.withValues(alpha: 0.25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileButton(
                    onTap: () => _onAssignPatientsButtonPressed(context),
                    icon: CupertinoIcons.person_fill,
                    text: "Assign Patients",
                  ),
                  ProfileButton(
                    onTap: () => _showContentDialog(
                      context,
                      "Terms of Services",
                    ),
                    icon: Icons.assignment,
                    text: "Terms of Services",
                  ),
                  ProfileButton(
                    onTap: () => _showContentDialog(
                      context,
                      "Privacy Policy",
                    ),
                    icon: Icons.security,
                    text: "Privacy Policy",
                  ),
                ],
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
                          color: Colors.black.withValues(alpha: 0.05),
                          spreadRadius: 10,
                          blurRadius: 20,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => _onLogoutButtonPressed(context),
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
                        elevation: WidgetStateProperty.all<double>(0),
                        shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                        overlayColor: WidgetStateProperty.all<Color>(Colors.white.withValues(alpha: 0.2)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
    );
  }

  void _onEditProfileButtonPressed(BuildContext context) {
    Navigator.of(context).pushNamed("/EditTherapistProfile", arguments: therapist);
  }

  void _onAssignPatientsButtonPressed(BuildContext context) {
    Navigator.of(context).pushNamed("/AssignPatients");
  }

  void _onLogoutButtonPressed(BuildContext context) {
    BlocProvider.of<TherapistBloc>(context).add(LogoutTherapistEvent(therapist));
  }

  void _showContentDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(right: 10, top: 10, left: 10),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          content: GlassContainer(
            blur: 10,
            color: Colors.white.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Sailec Bold',
                          fontSize: 22,
                          height: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Scrollbar(
                            trackVisibility: true,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      loremIpsum,
                                      style: TextStyle(
                                        fontFamily: 'Sailec Light',
                                        fontSize: 12,
                                        height: 1.2,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.center,
                    child: Theme(
                      data: darkButtonTheme,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

const String loremIpsum = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue. Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit sodales. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque fermentum. Maecenas adipiscing ante non diam sodales hendrerit.

Fusce lacinia arcu eu est. Quisque viverra molestie libero. Proin venenatis dui eget felis. Vestibulum tincidunt nisi sed augue. Curabitur vestibulum aliquam leo. Praesent egestas neque eu enim. In hac habitasse platea dictumst. Fusce a quam. Etiam ut purus mattis mauris sodales aliquam. Curabitur nisi. Quisque malesuada placerat nisl. Nam ipsum risus, rutrum vitae, vestibulum eu, molestie vel, lacus. Sed augue ipsum, egestas nec, vestibulum et, malesuada adipiscing, dui. Vestibulum facilisis, purus nec pulvinar iaculis, ligula mi congue nunc, vitae euismod ligula urna in dolor. Mauris sollicitudin fermentum libero. 

Nullam nonummy. Fusce aliquet pede non pede. Suspendisse dapibus lorem pellentesque magna. Integer nulla. Donec blandit feugiat ligula. Donec hendrerit, felis et imperdiet euismod, purus ipsum pretium metus, in lacinia nulla nisl eget sapien. Donec ut est in lectus consequat consequat. Etiam eget dui. Aliquam erat volutpat. Sed at lorem in nunc porta tristique. Proin nec augue. Quisque aliquam tempor magna. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nunc ac magna. Maecenas odio dolor, vulputate vel, auctor ac, accumsan id, felis. Pellentesque cursus sagittis felis. Pellentesque porttitor, velit lacinia egestas auctor, diam eros tempus arcu, nec vulputate augue magna vel risus. Cras non magna vel ante adipiscing rhoncus. Vivamus a mi. Morbi neque. Aliquam erat volutpat. Integer ultrices lobortis eros. 
''';
