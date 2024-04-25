import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/testing_item.dart';

class TestAnalytics extends StatelessWidget {
  final List<TestingItem> items;

  const TestAnalytics({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    List<String> staticPatterns = [];
    List<String> textures = [];
    List<String> rhythmicPatterns = [];
    List<double> staticPatternsScores = [];
    List<double> texturesScores = [];
    List<double> rhythmicPatternsScores = [];

    final accuracyList = items.map((item) => item.itemAccuracy).toList();
    double score = (accuracyList.reduce((value, element) => value + element) / accuracyList.length);

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      if (item.itemType == "static pattern") {
        staticPatterns.add(item.itemName);
        staticPatternsScores.add(item.itemAccuracy);
      } else if (item.itemType == "texture") {
        textures.add(item.itemName);
        texturesScores.add(item.itemAccuracy);
      } else {
        rhythmicPatterns.add(item.itemName);
        rhythmicPatternsScores.add(item.itemAccuracy);
      }
    }

    double averageStaticPatterns = staticPatternsScores.isNotEmpty ? staticPatternsScores.reduce((a, b) => a + b) / staticPatternsScores.length : 0;

    double averageTextures = texturesScores.isNotEmpty ? texturesScores.reduce((a, b) => a + b) / texturesScores.length : 0;
    double averageRhythmicPatterns = rhythmicPatternsScores.isNotEmpty ? rhythmicPatternsScores.reduce((a, b) => a + b) / rhythmicPatternsScores.length : 0;

    // print('TEST: $averageStaticPatterns');
    // print('TEST: $averageTextures');
    // print('TEST: $averageRhythmicPatterns');

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
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
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < items.length; i++)
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          items[i].itemName,
                                          style: darkTextTheme().headlineSmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(width: 24),
                                        Text(
                                          "${items[i].itemAccuracy.toString()}%",
                                          style: darkTextTheme().displaySmall,
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
                                foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white,
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xff128BED),
                                ),
                                elevation: MaterialStateProperty.all<double>(0),
                                shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
            items.first.test == "pretest" ? "Pre-test" : "Post-test",
            style: darkTextTheme().headlineLarge,
          ),
          Text(
            "Test Results",
            style: darkTextTheme().headlineSmall,
          ),
        ],
      ),
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
