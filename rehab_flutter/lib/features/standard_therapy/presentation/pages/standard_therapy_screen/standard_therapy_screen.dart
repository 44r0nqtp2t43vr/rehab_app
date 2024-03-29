import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';
import 'package:rehab_flutter/features/standard_therapy/domain/entities/standard_therapy_data.dart';
import 'package:rehab_flutter/features/standard_therapy/presentation/widgets/st_actuator.dart';

class StandardTherapyScreen extends StatefulWidget {
  final StandardTherapyData data;

  const StandardTherapyScreen({super.key, required this.data});

  @override
  State<StandardTherapyScreen> createState() => _StandardTherapyScreenState();
}

class _StandardTherapyScreenState extends State<StandardTherapyScreen> {
  int countdownDuration = 59;

  String getNameFromType() {
    switch (widget.data.type) {
      case StandardTherapy.actuatorTherapy:
        return "Actuator Therapy";
      case StandardTherapy.textureTherapy:
        return "Texture Therapy";
      case StandardTherapy.patternTherapy:
        return "Pattern Therapy";
      case StandardTherapy.pianoTiles:
        return "Music Stimulation - Basic";
      case StandardTherapy.musicVisualizer:
        return "Music Stimulation - Intermediate";
      default:
        return "";
    }
  }

  Widget getWidgetFromType() {
    switch (widget.data.type) {
      case StandardTherapy.actuatorTherapy:
        return STActuator(
          intensity: widget.data.intensity,
          countdownDuration: countdownDuration,
        );
      case StandardTherapy.textureTherapy:
        return Container();
      case StandardTherapy.patternTherapy:
        return Container();
      case StandardTherapy.pianoTiles:
        return Container();
      case StandardTherapy.musicVisualizer:
        return Container();
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
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Scaffold(
            body: Center(child: CupertinoActivityIndicator(color: Colors.white)),
          );
        }
        if (state is UserDone) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Standard Therapy",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    getNameFromType(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: getWidgetFromType(),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
