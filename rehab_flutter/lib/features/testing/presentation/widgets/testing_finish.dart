import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/core/widgets/app_button.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';

class TestingFinish extends StatefulWidget {
  final List<String> itemList;
  final List<double> accuracyList;

  const TestingFinish(
      {super.key, required this.itemList, required this.accuracyList});

  @override
  State<TestingFinish> createState() => _TestingFinishState();
}

class _TestingFinishState extends State<TestingFinish> {
  late double score;

  void _submitTest(AppUser user, double score) {
    BlocProvider.of<UserBloc>(context).add(SubmitTestEvent(ResultsData(
        user: user,
        score: score,
        isPretest: !user.getCurrentSession()!.getSessionConditions()[0])));
  }

  @override
  void initState() {
    final currentUser = BlocProvider.of<UserBloc>(context).state.currentUser!;
    score = (widget.accuracyList.reduce((value, element) => value + element) /
        widget.accuracyList.length);
    _submitTest(currentUser, score);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Assuming you have these variables to hold categorized data and average scores
    List<String> staticPatterns = [];
    List<String> textures = [];
    List<String> rhythmicPatterns = [];
    List<double> staticPatternsScores = [];
    List<double> texturesScores = [];
    List<double> rhythmicPatternsScores = [];

// Categorize items and calculate average scores
    for (int i = 0; i < widget.itemList.length; i++) {
      if (i < 10) {
        staticPatterns.add(widget.itemList[i]);
        staticPatternsScores.add(widget.accuracyList[i]);
      } else if (i < 15) {
        textures.add(widget.itemList[i]);
        texturesScores.add(widget.accuracyList[i]);
      } else {
        rhythmicPatterns.add(widget.itemList[i]);
        rhythmicPatternsScores.add(widget.accuracyList[i]);
      }
    }

// Calculate average scores
    double averageStaticPatterns = staticPatternsScores.isNotEmpty
        ? staticPatternsScores.reduce((a, b) => a + b) /
            staticPatternsScores.length
        : 0;
    double averageTextures = texturesScores.isNotEmpty
        ? texturesScores.reduce((a, b) => a + b) / texturesScores.length
        : 0;
    double averageRhythmicPatterns = rhythmicPatternsScores.isNotEmpty
        ? rhythmicPatternsScores.reduce((a, b) => a + b) /
            rhythmicPatternsScores.length
        : 0;

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(
              child: CupertinoActivityIndicator(color: Colors.white));
        }
        if (state is UserDone) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: GlassContainer(
                                  shadowStrength: 2,
                                  shadowColor: Colors.black,
                                  blur: 4,
                                  color: Colors.white.withOpacity(0.25),
                                  child: Container(
                                    height: 136,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 4,
                                child: GlassContainer(
                                  shadowStrength: 2,
                                  shadowColor: Colors.black,
                                  blur: 4,
                                  color: Colors.white.withOpacity(0.25),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 24,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircularPercentIndicator(
                                            radius: 0.4 * 136,
                                            lineWidth: 10.0,
                                            percent: score / 100,
                                            center: Text(
                                              "${score.toStringAsFixed(0)}%",
                                              style: const TextStyle(
                                                fontFamily: "Sailec Bold",
                                                fontSize: 24,
                                                color: Colors.white,
                                              ),
                                            ),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                            backgroundColor: Colors.white,
                                            progressColor:
                                                const Color(0xff01FF99),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Center(
                                            child: Text(
                                              "Overall Score",
                                              style:
                                                  darkTextTheme().displaySmall,
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Accuracy per Items",
                          style: darkTextTheme().displaySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < widget.itemList.length; i++)
                                Column(
                                  children: [
                                    GlassContainer(
                                      shadowStrength: 1,
                                      shadowColor: Colors.black,
                                      blur: 4,
                                      color: Colors.white.withOpacity(0.25),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              widget.itemList[i],
                                              style:
                                                  darkTextTheme().headlineSmall,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(width: 24),
                                            Text(
                                              "${widget.accuracyList[i].toString()}%",
                                              style:
                                                  darkTextTheme().displaySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 2,
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(score.toStringAsFixed(2)),
                    //           Text(widget.accuracyList.toString()),
                    //           Text(widget.itemList.toString()),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _onFinish(context),
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color(0xff128BED),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    shadowColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent),
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.transparent),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: const Text('Finish'),
                                ),
                              ),
                              // AppButton(
                              //   onPressed: () => _onFinish(context),
                              //   child: const Text('Finish'),
                              // ),
                            ],
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
        return const SizedBox();
      },
    );
  }

  void _onFinish(BuildContext context) {
    Navigator.of(context).pop();
  }
}
