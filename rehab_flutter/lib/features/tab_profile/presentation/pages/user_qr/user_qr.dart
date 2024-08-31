import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';

class UserQR extends StatelessWidget {
  const UserQR({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lotties/loading-1.json',
                width: 400,
                height: 400,
              ),
            ),
          );
        }
        if (state is UserDone) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              size: 35,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "QR Code",
                                style: darkTextTheme().headlineLarge,
                              ),
                              Text(
                                "Your Personal QR Code",
                                style: darkTextTheme().headlineSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 34,
                                child: state.currentUser!.imageURL != null
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: state.currentUser!.imageURL!,
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
                              const SizedBox(height: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.currentUser!.getUserFullName(),
                                    style: const TextStyle(
                                      fontFamily: 'Sailec Bold',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    state.currentUser!.email,
                                    style: darkTextTheme().headlineSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          GlassContainer(
                            shadowStrength: 2,
                            shadowColor: Colors.black,
                            blur: 4,
                            color: Colors.white.withOpacity(0.25),
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: PrettyQrView.data(data: state.currentUser!.userId),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  "Connect to your Therapist by sharing this QR Code.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Sailec Medium',
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
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
        return const SizedBox();
      },
    );
  }
}
