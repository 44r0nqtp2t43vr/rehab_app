import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';

class ActivityChartCard extends StatelessWidget {
  final List<Plan> plans;

  const ActivityChartCard({super.key, required this.plans});

  Widget buildLineChartOrText() {
    LineChartData? lineChartData = buildLineChartData();

    if (lineChartData != null) {
      return LineChart(
        lineChartData,
      );
    } else {
      return const Center(
        child: Text(
          'Complete your Session Today.',
          style: TextStyle(
            fontFamily: 'Sailec Medium',
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );
    }
  }

  double calculateIncreasePercentage() {
    List<double> activityPercentages = getActivityPercentagesFromLastThreeDays();

    return activityPercentages[2] - activityPercentages[1];
  }

  LineChartData? buildLineChartData() {
    List<double> previousPostTestScores = getActivityPercentagesFromLastThreeDays();

    List<FlSpot> dataPoints = [];

    for (int i = 0; i < previousPostTestScores.length; i++) {
      dataPoints.add(FlSpot(i.toDouble(), previousPostTestScores[i]));
    }

    return LineChartData(
      minY: 0,
      maxY: 100,
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: dataPoints,
          isCurved: false,
          color: const Color(0xff01FF99),
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xff01FF99).withValues(alpha: 0.3),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchSpotThreshold: 50,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) {
            return Colors.transparent;
          },
          tooltipPadding: const EdgeInsets.all(4),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((touchedSpot) {
              const TextStyle textStyle = TextStyle(
                color: Color(0xff01FF99),
                fontFamily: 'Sailec Medium',
                fontSize: 14,
              );
              return LineTooltipItem(
                touchedSpot.y.toStringAsFixed(1),
                textStyle,
              );
            }).toList();
          },
        ),
      ),
    );
  }

  List<double> getActivityPercentagesFromLastThreeDays() {
    if (plans.isEmpty) {
      return [0, 0, 0];
    }

    final todayString = formatDateMMDDYYYY(DateTime.now());
    final yesterdayString = formatDateMMDDYYYY(DateTime.now().subtract(const Duration(days: 1)));
    final twoDaysAgoString = formatDateMMDDYYYY(DateTime.now().subtract(const Duration(days: 2)));

    final List<Plan> plansToSearch = [];
    for (int i = 0; i < plans.length; i++) {
      if (plans[i].endDate.isAfter(DateTime.now())) {
        plansToSearch.add(plans[i]);
        if (i > 0) {
          plansToSearch.insert(0, plans[i - 1]);
        }
        break;
      }
    }

    final List<String> allDailyActivities = [];
    for (var plan in plansToSearch) {
      for (var session in plan.sessions) {
        allDailyActivities.addAll(session.dailyActivities);
      }
    }

    final todayIndex = allDailyActivities.indexWhere((daString) => daString.startsWith(todayString));

    int yesterdayIndex = -1;
    int twoDaysAgoIndex = -1;

    if (todayIndex > 0) {
      yesterdayIndex = allDailyActivities[todayIndex - 1].startsWith(yesterdayString) ? todayIndex - 1 : -1;
    }
    if (todayIndex > 1) {
      twoDaysAgoIndex = allDailyActivities[todayIndex - 2].startsWith(twoDaysAgoString) ? todayIndex - 2 : -1;
    }

    final List<String> lastThreeDailyActivities = [
      twoDaysAgoIndex != -1 ? allDailyActivities[twoDaysAgoIndex] : "",
      yesterdayIndex != -1 ? allDailyActivities[yesterdayIndex] : "",
      todayIndex != -1 ? allDailyActivities[todayIndex] : "",
    ];

    final List<double> activityPercentages = [];
    for (var str in lastThreeDailyActivities) {
      if (str.isEmpty) {
        activityPercentages.add(0);
        continue;
      }

      final activityBools = str.split("_")[3];
      final tCount = activityBools.split('').where((char) => char == 't').length;

      double percentage = (tCount / activityBools.length) * 100;
      activityPercentages.add(percentage);
    }

    return activityPercentages;
  }

  @override
  Widget build(BuildContext context) {
    double increasePercentage = calculateIncreasePercentage();

    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Increase in Activity',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Sailec Light',
                fontSize: 11,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "${increasePercentage.toStringAsFixed(0)}%",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Sailec Bold',
                height: 1,
                fontSize: 36,
              ),
            ),
            Expanded(
              child: buildLineChartOrText(),
            ),
          ],
        ),
      ),
    );
  }
}
