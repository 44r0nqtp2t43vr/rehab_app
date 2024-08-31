import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';
import 'package:rehab_flutter/core/entities/testing_item.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/test_analytics_item.dart';
import 'package:rehab_flutter/features/tab_home/presentation/bloc/patient_current_session/patient_current_session_bloc.dart';
import 'package:rehab_flutter/features/testing/domain/entities/results_data.dart';

class TestingFinish extends StatefulWidget {
  final List<String> itemList;
  final List<double> accuracyList;

  const TestingFinish({super.key, required this.itemList, required this.accuracyList});

  @override
  State<TestingFinish> createState() => _TestingFinishState();
}

class _TestingFinishState extends State<TestingFinish> {
  late double score;

  void _submitTest(AppUser user, double score) {
    final currentSession = BlocProvider.of<PatientCurrentSessionBloc>(context).state.currentSession!;
    bool isPretest = currentSession.getSessionConditions()[0];

    List<TestingItem> items = [];
    for (var i = 0; i < widget.itemList.length; i++) {
      final nextItem = TestingItem(
        test: isPretest ? "pretest" : "posttest",
        itemNumber: i + 1,
        itemName: widget.itemList[i],
        itemType: i < 10
            ? "static pattern"
            : i < 15
                ? "texture"
                : "rhythmic pattern",
        itemAccuracy: widget.accuracyList[i],
      );

      items.add(nextItem);
    }

    BlocProvider.of<UserBloc>(context).add(SubmitTestEvent(
      ResultsData(
        user: user,
        currentSession: currentSession,
        score: score,
        isPretest: isPretest,
        items: items,
      ),
    ));
  }

  @override
  void initState() {
    final currentUser = BlocProvider.of<UserBloc>(context).state.currentUser!;
    score = (widget.accuracyList.reduce((value, element) => value + element) / widget.accuracyList.length);
    _submitTest(currentUser, score);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> staticPatterns = [];
    List<String> textures = [];
    List<String> rhythmicPatterns = [];
    List<double> staticPatternsScores = [];
    List<double> texturesScores = [];
    List<double> rhythmicPatternsScores = [];

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

    double averageStaticPatterns = staticPatternsScores.isNotEmpty ? staticPatternsScores.reduce((a, b) => a + b) / staticPatternsScores.length : 0;

    double averageTextures = texturesScores.isNotEmpty ? texturesScores.reduce((a, b) => a + b) / texturesScores.length : 0;
    double averageRhythmicPatterns = rhythmicPatternsScores.isNotEmpty ? rhythmicPatternsScores.reduce((a, b) => a + b) / rhythmicPatternsScores.length : 0;

    // print('TEST: $averageStaticPatterns');
    // print('TEST: $averageTextures');
    // print('TEST: $averageRhythmicPatterns');

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(
            child: Lottie.asset(
              'assets/lotties/uploading.json',
              width: 400,
              height: 400,
            ),
            //CupertinoActivityIndicator(color: Colors.white),
          );
        }
        if (state is UserDone) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    SizedBox(
                      height: 280,
                      child: Row(
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Average Accuracy",
                                            style: darkTextTheme().displaySmall,
                                          ),
                                          const Text(
                                            "Per item Category",
                                            style: TextStyle(
                                              fontFamily: 'Sailec Light',
                                              fontSize: 12,
                                              height: 1.2,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Expanded(
                                            child: BarChart(
                                              BarChartData(
                                                groupsSpace: 12,
                                                alignment: BarChartAlignment.spaceAround,
                                                maxY: 100,
                                                titlesData: FlTitlesData(
                                                  topTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      interval: 20,
                                                      reservedSize: 28,
                                                      showTitles: true,
                                                      getTitlesWidget: (value, meta) {
                                                        return SideTitleWidget(
                                                          axisSide: AxisSide.left,
                                                          child: Text(
                                                            value.toStringAsFixed(0),
                                                            style: const TextStyle(
                                                              fontFamily: 'Sailec Medium',
                                                              fontSize: 8,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  rightTitles: const AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                    ),
                                                  ),
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      reservedSize: 35,
                                                      showTitles: true,
                                                      getTitlesWidget: bottomTitles,
                                                    ),
                                                  ),
                                                ),
                                                borderData: FlBorderData(
                                                  show: true,
                                                  border: const Border(
                                                    left: BorderSide(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                    bottom: BorderSide(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                barGroups: [
                                                  BarChartGroupData(x: 0, barRods: [
                                                    BarChartRodData(
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(4),
                                                        topRight: Radius.circular(4),
                                                        bottomLeft: Radius.zero,
                                                        bottomRight: Radius.zero,
                                                      ),
                                                      width: 20,
                                                      toY: averageStaticPatterns,
                                                      color: const Color(0xffdbfff0),
                                                    ),
                                                  ]),
                                                  BarChartGroupData(x: 1, barRods: [
                                                    BarChartRodData(
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(4),
                                                        topRight: Radius.circular(4),
                                                        bottomLeft: Radius.zero,
                                                        bottomRight: Radius.zero,
                                                      ),
                                                      width: 20,
                                                      toY: averageTextures,
                                                      color: const Color(0xFF49ffb6),
                                                    ),
                                                  ]),
                                                  BarChartGroupData(x: 2, barRods: [
                                                    BarChartRodData(
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(4),
                                                        topRight: Radius.circular(4),
                                                        bottomLeft: Radius.zero,
                                                        bottomRight: Radius.zero,
                                                      ),
                                                      width: 20,
                                                      toY: averageRhythmicPatterns,
                                                      color: const Color(0xFF00b66d),
                                                    ),
                                                  ]),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  _buildLegendItem(
                                                    const Color(0xffdbfff0),
                                                  ),
                                                  const Text(
                                                    'SP: Static Patterns',
                                                    style: TextStyle(
                                                      fontFamily: 'Sailec Medium',
                                                      fontSize: 8,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  _buildLegendItem(
                                                    const Color(0xFF49ffb6),
                                                  ),
                                                  const Text(
                                                    'T: Textures',
                                                    style: TextStyle(
                                                      fontFamily: 'Sailec Medium',
                                                      fontSize: 8,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Row(
                                                children: [
                                                  _buildLegendItem(
                                                    const Color(0xFF00b66d),
                                                  ),
                                                  const Text(
                                                    'RP: Rhythmic Patterns',
                                                    style: TextStyle(
                                                      fontFamily: 'Sailec Medium',
                                                      fontSize: 8,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                              circularStrokeCap: CircularStrokeCap.round,
                                              backgroundColor: Colors.white,
                                              progressColor: const Color(0xff01FF99),
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            Center(
                                              child: Text(
                                                "Overall Score",
                                                style: darkTextTheme().displaySmall,
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.itemList.length,
                      itemBuilder: (context, i) {
                        final nextItem = TestingItem(
                          test: "",
                          itemNumber: i + 1,
                          itemName: widget.itemList[i],
                          itemType: i < 10
                              ? "static pattern"
                              : i < 15
                                  ? "texture"
                                  : "rhythmic pattern",
                          itemAccuracy: widget.accuracyList[i],
                        );

                        return Column(
                          children: [
                            TestAnalyticsItem(
                              itemName: nextItem.itemName,
                              itemType: nextItem.itemType,
                              itemAccuracy: nextItem.itemAccuracy,
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
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
                                    foregroundColor: WidgetStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    backgroundColor: WidgetStateProperty.all<Color>(
                                      const Color(0xff128BED),
                                    ),
                                    elevation: WidgetStateProperty.all<double>(0),
                                    shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
                                    overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontFamily: 'Sailec Medium',
      fontSize: 8,
      color: Colors.white,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'SP';
        break;
      case 1:
        text = 'T';
        break;
      case 2:
        text = 'RP';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget _buildLegendItem(Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  void _onFinish(BuildContext context) {
    Navigator.of(context).pop();
  }
}
