import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/features/patients_manager/presentation/widgets/test_analytics_item.dart';

class TestAnalytics extends StatelessWidget {
  final List<String> testingItems;

  const TestAnalytics({super.key, required this.testingItems});

  List<double> calculateAverages() {
    int overallSum = 0;
    int firstTenSum = 0;
    // int elevenToFifteenSum = 0;
    // int sixteenToTwentySum = 0;
    int elevenToTwentySum = 0;

    for (int i = 0; i < testingItems.length; i++) {
      final testingItemDetailsList = testingItems[i].split("_");
      final itemName = testingItemDetailsList[2];
      final answer = testingItemDetailsList[3];

      if (i < 10) {
        if (answer == itemName[0]) {
          overallSum += 1;
          firstTenSum += 1;
        }
      } else {
        if (answer == itemName.split(" ")[0]) {
          overallSum += 1;
          elevenToTwentySum += 1;
        }
      }
    }

    return [(overallSum / 20) * 100, (firstTenSum / 10) * 100, (elevenToTwentySum / 5) * 100];
  }

  @override
  Widget build(BuildContext context) {
    final scores = calculateAverages();

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
                                // shadowColor: Colors.black,
                                blur: 4,
                                color: Colors.white.withValues(alpha: 0.25),
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
                                                  toY: scores[1],
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
                                                  toY: scores[2],
                                                  color: const Color(0xFF49ffb6),
                                                ),
                                              ]),
                                              // BarChartGroupData(x: 2, barRods: [
                                              //   BarChartRodData(
                                              //     borderRadius: const BorderRadius.only(
                                              //       topLeft: Radius.circular(4),
                                              //       topRight: Radius.circular(4),
                                              //       bottomLeft: Radius.zero,
                                              //       bottomRight: Radius.zero,
                                              //     ),
                                              //     width: 20,
                                              //     toY: scores[3],
                                              //     color: const Color(0xFF00b66d),
                                              //   ),
                                              // ]),
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
                                                '2PD: 2-Point Discrimination',
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
                                                'TD: Tactile Discrimination',
                                                style: TextStyle(
                                                  fontFamily: 'Sailec Medium',
                                                  fontSize: 8,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(
                                          //   height: 8,
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     _buildLegendItem(
                                          //       const Color(0xFF00b66d),
                                          //     ),
                                          //     const Text(
                                          //       'T: Textures',
                                          //       style: TextStyle(
                                          //         fontFamily: 'Sailec Medium',
                                          //         fontSize: 8,
                                          //         color: Colors.white,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
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
                                // shadowColor: Colors.black,
                                blur: 4,
                                color: Colors.white.withValues(alpha: 0.25),
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
                                          percent: scores[0] / 100,
                                          center: Text(
                                            "${scores[0].toStringAsFixed(0)}%",
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
                    Expanded(
                      flex: 4,
                      child: Text(
                        "Correct Answers",
                        style: darkTextTheme().displaySmall,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        "Submitted Answers",
                        style: darkTextTheme().displaySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: testingItems.length,
                  itemBuilder: (context, i) {
                    final testingItemDetailsList = testingItems[i].split("_");
                    final itemName = testingItemDetailsList[2];
                    final answer = testingItemDetailsList[3];

                    return Column(
                      children: [
                        TestAnalyticsItem(
                          itemName: itemName,
                          answer: answer,
                          isCorrect: i < 10 ? answer == itemName[0] : answer == itemName.split(" ")[0],
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
                                // shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
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
            "Weekly Test",
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
        text = '2PD';
        break;
      case 1:
        text = 'TD';
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
