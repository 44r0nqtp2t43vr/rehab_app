import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/data_sources/song_provider.dart';
import 'package:rehab_flutter/core/entities/song.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_data.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_therapy_data.dart';
import 'package:rehab_flutter/features/standard_therapy/presentation/widgets/st_actuator.dart';
import 'package:rehab_flutter/features/standard_therapy/presentation/widgets/st_patterns.dart';
import 'package:rehab_flutter/features/standard_therapy/presentation/widgets/st_pianotiles.dart';
import 'package:rehab_flutter/features/standard_therapy/presentation/widgets/st_textures.dart';
import 'package:rehab_flutter/features/standard_therapy/presentation/widgets/st_visualizer.dart';

class StandardTherapyScreen extends StatefulWidget {
  final StandardTherapyData data;

  const StandardTherapyScreen({super.key, required this.data});

  @override
  State<StandardTherapyScreen> createState() => _StandardTherapyScreenState();
}

class _StandardTherapyScreenState extends State<StandardTherapyScreen> {
  int countdownDuration = 299;

  void submit() {
    BlocProvider.of<UserBloc>(context).add(SubmitStandardEvent(StandardData(userId: widget.data.userId, isStandardOne: widget.data.isStandardOne)));
  }

  Song getSongFromIntensity() {
    final random = Random();
    final songList = SongProvider.songs;

    songList.sort((a, b) => a.noteCountsPerFrame.compareTo(b.noteCountsPerFrame));

    int startIndex = (songList.length * (widget.data.intensity - 1) ~/ 5).toInt();
    int endIndex = (songList.length * widget.data.intensity ~/ 5).toInt();

    return songList[startIndex + random.nextInt(endIndex - startIndex)];
  }

  String getNameFromType() {
    switch (widget.data.type) {
      case StandardTherapy.actuatorTherapy:
        return "Point Discrimination";
      case StandardTherapy.textureTherapy:
        return "Texture Discrimination";
      case StandardTherapy.patternTherapy:
        return "Pattern Discrimination";
      case StandardTherapy.pianoTiles:
        return "Music Stimulation - Basic";
      case StandardTherapy.musicVisualizer:
        return "Music Stimulation - Intermediate";
      default:
        return "";
    }
  }

  Widget getWidgetFromType(AppUser user) {
    switch (widget.data.type) {
      case StandardTherapy.actuatorTherapy:
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: STActuator(
            user: user,
            intensity: widget.data.intensity,
            countdownDuration: countdownDuration,
            submitCallback: submit,
          ),
        );
      case StandardTherapy.textureTherapy:
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: STTextures(
            user: user,
            intensity: widget.data.intensity,
            countdownDuration: countdownDuration,
            submitCallback: submit,
          ),
        );
      case StandardTherapy.patternTherapy:
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: STPatterns(
            user: user,
            intensity: widget.data.intensity,
            countdownDuration: countdownDuration,
            submitCallback: submit,
          ),
        );
      case StandardTherapy.pianoTiles:
        return STPianoTiles(user: user, song: getSongFromIntensity(), submitCallback: submit);
      case StandardTherapy.musicVisualizer:
        return STVisualizer(user: user, song: getSongFromIntensity(), submitCallback: submit);
      default:
        return Container();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listenWhen: (previous, current) => previous is UserLoading && current is UserDone,
      listener: (context, state) {
        if (state is UserDone) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lotties/uploading.json',
                width: 400,
                height: 400,
              ),
              //CupertinoActivityIndicator(color: Colors.white),
            ),
          );
        }
        if (state is UserDone) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  size: 35,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Standard Therapy",
                    style: darkTextTheme().headlineLarge,
                  ),
                  Text(
                    getNameFromType(),
                    style: darkTextTheme().headlineSmall,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.check,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () => submit(),
                ),
              ],
            ),
            body: getWidgetFromType(state.currentUser!),
          );
        }
        return const SizedBox();
      },
    );
  }
}
