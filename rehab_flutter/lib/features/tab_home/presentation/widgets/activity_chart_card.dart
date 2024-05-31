import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class ActivityChartCard extends StatelessWidget {
  final AppUser? user;
  final Plan? currentPlan;

  const ActivityChartCard({super.key, this.user, this.currentPlan});

  @override
  Widget build(BuildContext context) {
    if (currentPlan == null && user != null) {
      double increasePercentage = calculateIncreasePercentage(user!);
      bool hasPlans = user!.getCurrentPlan() != null;

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
                hasPlans ? "${increasePercentage.toStringAsFixed(0)}%" : 'No Active Plans',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Sailec Bold',
                  height: 1,
                  fontSize: hasPlans ? 36 : 24,
                ),
              ),
              Expanded(
                child: hasPlans ? buildLineChartOrText(user!) : Container(),
              ),
            ],
          ),
        ),
      );
    } else if (currentPlan != null && user == null) {
      double increasePercentage = calculateIncreasePercentageFromPlan(currentPlan!);
      bool hasPlans = currentPlan!.planId != Plan.empty().planId;

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
                hasPlans ? "${increasePercentage.toStringAsFixed(0)}%" : 'No Active Plans',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Sailec Bold',
                  height: 1,
                  fontSize: hasPlans ? 36 : 24,
                ),
              ),
              Expanded(
                child: hasPlans ? buildLineChartOrTextFromPlan(currentPlan!) : Container(),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
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

  for (var session in allSessions) {
    if (session.date.year == yesterday.year && session.date.month == yesterday.month && session.date.day == yesterday.day) {
      if (session.posttestScore != null) {
        previousPostTestScore = session.posttestScore!;
        hasPreviousScores = true;
      }
    } else if (session.date.year == today.year && session.date.month == today.month && session.date.day == today.day) {
      if (session.posttestScore != null) {
        currentPostTestScore = session.posttestScore!;
      }
    }
  }

  double increasePercentage = 0;

  if (hasPreviousScores) {
    if (previousPostTestScore != 0) {
      increasePercentage = ((currentPostTestScore - previousPostTestScore) / previousPostTestScore) * 100;
    }
  } else {
    if (currentPostTestScore != 0) {
      increasePercentage = 100;
    }
  }

  // print('Increase percentage: $increasePercentage');

  // if (currentPostTestScore == 0) {
  //   increasePercentage = 0;
  // }

  return increasePercentage;
}

LineChartData? buildLineChartData(AppUser user) {
  List<Session> allSessions = user.getAllSessionsFromAllPlans();

  final DateTime today = DateTime.now();

  List<double> previousPostTestScores = [0, 0, 0];

  for (int i = 0; i < 3; i++) {
    DateTime date = today.subtract(Duration(days: i));
    Session? session = allSessions.firstWhere(
      (session) => session.date.year == date.year && session.date.month == date.month && session.date.day == date.day,
      orElse: () => Session.empty(),
    );

    if (session.posttestScore != null) {
      previousPostTestScores[2 - i] = session.posttestScore!;
    } else {
      previousPostTestScores[2 - i] = 0;
    }
  }

  double currentPostTestScore = user.getCurrentSession()?.posttestScore ?? 0;
  previousPostTestScores[2] = currentPostTestScore;

  print('prev $previousPostTestScores');

  List<FlSpot> dataPoints = [];

  for (int i = 0; i < previousPostTestScores.length; i++) {
    dataPoints.add(FlSpot(i.toDouble(), previousPostTestScores[i]));
  }

  double maxY = previousPostTestScores.isNotEmpty ? previousPostTestScores.reduce((curr, next) => curr > next ? curr : next) : 0;
  double minY = previousPostTestScores.isNotEmpty ? previousPostTestScores.reduce((curr, next) => curr < next ? curr : next) : 0;

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

Widget buildLineChartOrTextFromPlan(Plan currentPlan) {
  LineChartData? lineChartData = buildLineChartDataFromPlan(currentPlan);

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

double calculateIncreasePercentageFromPlan(Plan currentPlan) {
  List<Session> allSessions = currentPlan.sessions;
  final DateTime today = DateTime.now();
  final DateTime yesterday = today.subtract(const Duration(days: 1));

  double previousPostTestScore = 0;
  double currentPostTestScore = 0;

  bool hasPreviousScores = false;

  for (var session in allSessions) {
    if (session.date.year == yesterday.year && session.date.month == yesterday.month && session.date.day == yesterday.day) {
      if (session.posttestScore != null) {
        previousPostTestScore = session.posttestScore!;
        hasPreviousScores = true;
      }
    } else if (session.date.year == today.year && session.date.month == today.month && session.date.day == today.day) {
      if (session.posttestScore != null) {
        currentPostTestScore = session.posttestScore!;
      }
    }
  }

  double increasePercentage = 0;

  if (hasPreviousScores) {
    if (previousPostTestScore != 0) {
      increasePercentage = ((currentPostTestScore - previousPostTestScore) / previousPostTestScore) * 100;
    }
  } else {
    if (currentPostTestScore != 0) {
      increasePercentage = 100;
    }
  }

  // print('Increase percentage: $increasePercentage');

  // if (currentPostTestScore == 0) {
  //   increasePercentage = 0;
  // }

  return increasePercentage;
}

LineChartData? buildLineChartDataFromPlan(Plan currentPlan) {
  List<Session> allSessions = currentPlan.sessions;

  final DateTime today = DateTime.now();

  List<double> previousPostTestScores = [0, 0, 0];

  for (int i = 0; i < 3; i++) {
    DateTime date = today.subtract(Duration(days: i));
    Session? session = allSessions.firstWhere(
      (session) => session.date.year == date.year && session.date.month == date.month && session.date.day == date.day,
      orElse: () => Session.empty(),
    );

    if (session.posttestScore != null) {
      previousPostTestScores[2 - i] = session.posttestScore!;
    } else {
      previousPostTestScores[2 - i] = 0;
    }
  }

  double currentPostTestScore = currentPlan.getCurrentSession()?.posttestScore ?? 0;
  previousPostTestScores[2] = currentPostTestScore;

  print('prev $previousPostTestScores');

  List<FlSpot> dataPoints = [];

  for (int i = 0; i < previousPostTestScores.length; i++) {
    dataPoints.add(FlSpot(i.toDouble(), previousPostTestScores[i]));
  }

  double maxY = previousPostTestScores.isNotEmpty ? previousPostTestScores.reduce((curr, next) => curr > next ? curr : next) : 0;
  double minY = previousPostTestScores.isNotEmpty ? previousPostTestScores.reduce((curr, next) => curr < next ? curr : next) : 0;

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
