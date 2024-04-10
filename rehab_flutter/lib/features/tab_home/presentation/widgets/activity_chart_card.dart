import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class ActivityChartCard extends StatelessWidget {
  final AppUser user;

  const ActivityChartCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    double increasePercentage = calculateIncreasePercentage(user);
    bool hasPlans = user.getCurrentPlan() != null;

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
              hasPlans
                  ? "${increasePercentage.toStringAsFixed(0)}%"
                  : 'No Active Plans',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Sailec Bold',
                height: 1,
                fontSize: hasPlans ? 36 : 24,
              ),
            ),
            Expanded(
              child: hasPlans ? buildLineChartOrText(user) : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildLineChartOrText(AppUser user) {
  LineChartData? lineChartData = buildLineChartData(user);

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

double calculateIncreasePercentage(AppUser user) {
  List<Session> allSessions = user.getAllSessionsFromAllPlans();
  final DateTime today = DateTime.now();
  final DateTime yesterday = today.subtract(const Duration(days: 1));

  double previousPostTestScore = 0;
  double currentPostTestScore = 0;

  bool hasPreviousScores = false;

  // Check if there are previous posttest scores
  for (var session in allSessions) {
    if (session.date.year == yesterday.year &&
        session.date.month == yesterday.month &&
        session.date.day == yesterday.day) {
      if (session.posttestScore != null) {
        previousPostTestScore = session.posttestScore!;
        hasPreviousScores = true;
      }
    } else if (session.date.year == today.year &&
        session.date.month == today.month &&
        session.date.day == today.day) {
      if (session.posttestScore != null) {
        currentPostTestScore = session.posttestScore!;
      }
    }
  }

  double increasePercentage = 0;

  if (hasPreviousScores) {
    // Calculate increase percentage based on previous posttest score
    if (previousPostTestScore != 0) {
      increasePercentage = ((currentPostTestScore - previousPostTestScore) /
              previousPostTestScore) *
          100;
    }
  } else {
    // If there are no previous posttest scores, calculate increase percentage from 0%
    if (currentPostTestScore != 0) {
      increasePercentage = 100;
    }
  }

  // print('Increase percentage: $increasePercentage');

  return increasePercentage;
}

LineChartData? buildLineChartData(AppUser user) {
  List<Session> allSessions = user.getAllSessionsFromAllPlans();

  final DateTime today = DateTime.now();
  final DateTime threeDaysAgo = today.subtract(const Duration(days: 3));

  List<double> previousPostTestScores = [];
  bool hasPreviousScores = false;

  for (var session in allSessions) {
    if (session.date.isAfter(threeDaysAgo) &&
        session.date.isBefore(today) &&
        session.posttestScore != null) {
      previousPostTestScores.add(session.posttestScore!);
      hasPreviousScores = true;
    }
  }

  if (hasPreviousScores == false) {
    return null;
  }

  // If there's only one score, add an additional point at the beginning representing 0%
  if (previousPostTestScores.length == 1) {
    previousPostTestScores.insert(0, 0);
  }

  List<FlSpot> dataPoints = [];
  for (int i = 0; i < previousPostTestScores.length; i++) {
    dataPoints.add(FlSpot(i.toDouble(), previousPostTestScores[i]));
  }

  double maxY = previousPostTestScores.isNotEmpty
      ? previousPostTestScores.reduce((curr, next) => curr > next ? curr : next)
      : 0;
  double minY = previousPostTestScores.isNotEmpty
      ? previousPostTestScores.reduce((curr, next) => curr < next ? curr : next)
      : 0;

  double centerValue = (maxY + minY) / 2;

  return LineChartData(
    minY: centerValue - 50,
    maxY: centerValue + 50,
    gridData: const FlGridData(show: false),
    titlesData: const FlTitlesData(show: false),
    borderData: FlBorderData(show: false),
    lineBarsData: [
      LineChartBarData(
        spots: dataPoints,
        isCurved: true,
        color: const Color(0xff01FF99),
        barWidth: 4,
        isStrokeCapRound: true,
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0xff01FF99).withOpacity(0.3),
        ),
      ),
    ],
  );
}
