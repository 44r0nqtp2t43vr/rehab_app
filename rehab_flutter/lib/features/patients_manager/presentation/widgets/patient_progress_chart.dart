import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/patient_sessions.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/patient_progress_type.dart';

class PatientProgressChart extends StatefulWidget {
  final List<PatientSessions> patients;

  const PatientProgressChart({super.key, required this.patients});

  @override
  State<PatientProgressChart> createState() => _PatientProgressChartState();
}

class _PatientProgressChartState extends State<PatientProgressChart> {
  final List<String> _availableTypes = availableTypes;
  late List<PatientSessions> _patients;
  late String _currentType;
  PatientSessions? _patient;

  void _onTypeDropdownSelect(String? newValue) {
    setState(() {
      _currentType = newValue!;
    });
  }

  void _onPatientDropdownSelect(PatientSessions? newValue) {
    setState(() {
      _patient = newValue!;
    });
  }

  @override
  void initState() {
    _patients = widget.patients;
    _patient = widget.patients.isNotEmpty ? widget.patients[0] : null;
    _currentType = availableTypes[0];
    super.initState();
  }

  @override
  void didUpdateWidget(PatientProgressChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.patients != _patients) {
      // Data has changed, trigger a rebuild
      setState(() {
        _patients = widget.patients;
        _patient = widget.patients[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      shadowStrength: 2,
      // shadowColor: Colors.black,
      blur: 4,
      color: Colors.white.withValues(alpha: 0.25),
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: Padding(
              padding: const EdgeInsets.only(top: 24, right: 24, bottom: 20, left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: buildLineChartOrText(_patient),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, right: 24, bottom: 24, left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  "Type:",
                  style: TextStyle(
                    fontFamily: 'Sailec Medium',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _currentType,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Sailec Medium',
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  decoration: customDropdownDecoration.copyWith(
                    labelText: 'Type',
                  ),
                  onChanged: _onTypeDropdownSelect,
                  items: _availableTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Patient Name:",
                  style: TextStyle(
                    fontFamily: 'Sailec Medium',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<PatientSessions>(
                  value: _patient,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Sailec Medium',
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  decoration: customDropdownDecoration.copyWith(
                    labelText: 'Patient',
                  ),
                  onChanged: _onPatientDropdownSelect,
                  items: widget.patients.map<DropdownMenuItem<PatientSessions>>((PatientSessions patient) {
                    return DropdownMenuItem<PatientSessions>(
                      value: patient,
                      child: Text(patient.patient.getUserFullName()),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<double> getActivityPercentagesFromLastFiveDays() {
    if (_patient == null || _patient!.sessions.isEmpty) {
      return [0, 0, 0, 0, 0];
    }

    final todayString = formatDateMMDDYYYY(DateTime.now());
    final yesterdayString = formatDateMMDDYYYY(DateTime.now().subtract(const Duration(days: 1)));
    final twoDaysAgoString = formatDateMMDDYYYY(DateTime.now().subtract(const Duration(days: 2)));
    final threeDaysAgoString = formatDateMMDDYYYY(DateTime.now().subtract(const Duration(days: 3)));
    final fourDaysAgoString = formatDateMMDDYYYY(DateTime.now().subtract(const Duration(days: 4)));

    final List<String> allDailyActivities = [];
    for (var session in _patient!.sessions) {
      allDailyActivities.addAll(session.dailyActivities);
    }

    final todayIndex = allDailyActivities.indexWhere((daString) => daString.startsWith(todayString));

    int yesterdayIndex = -1;
    int twoDaysAgoIndex = -1;
    int threeDaysAgoIndex = -1;
    int fourDaysAgoIndex = -1;

    if (todayIndex > 0) {
      yesterdayIndex = allDailyActivities[todayIndex - 1].startsWith(yesterdayString) ? todayIndex - 1 : -1;
    }
    if (todayIndex > 1) {
      twoDaysAgoIndex = allDailyActivities[todayIndex - 2].startsWith(twoDaysAgoString) ? todayIndex - 2 : -1;
    }
    if (todayIndex > 2) {
      threeDaysAgoIndex = allDailyActivities[todayIndex - 3].startsWith(threeDaysAgoString) ? todayIndex - 3 : -1;
    }
    if (todayIndex > 3) {
      fourDaysAgoIndex = allDailyActivities[todayIndex - 4].startsWith(fourDaysAgoString) ? todayIndex - 4 : -1;
    }

    final List<String> lastThreeDailyActivities = [
      fourDaysAgoIndex != -1 ? allDailyActivities[fourDaysAgoIndex] : "",
      threeDaysAgoIndex != -1 ? allDailyActivities[threeDaysAgoIndex] : "",
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

  Map<String, List<dynamic>> getTestScoresFromLastFiveTests() {
    if (_patient == null || _patient!.sessions.isEmpty) {
      return {
        'dates': ["", "", "", "", ""],
        'scores': [0, 0, 0, 0, 0],
      };
    }

    final Map<String, List<String>> allTestingItems = {};
    for (var session in _patient!.sessions) {
      if (session.testingItems.isEmpty) {
        continue;
      }

      final dateString = session.testingItems[0].split("_")[0];
      final date = parseMMDDYYYY(dateString);
      final dateKey = formatDateMMDD(date);
      allTestingItems[dateKey] = List.from(session.testingItems);
    }

    if (allTestingItems.keys.isEmpty) {
      return {
        'dates': ["", "", "", "", ""],
        'scores': [0, 0, 0, 0, 0],
      };
    }

    final List<double> testScores = [];
    List<String> testDates = allTestingItems.keys.toList();

    if (testDates.length > 5) {
      testDates = testDates.sublist(testDates.length - 5, testDates.length);
    }

    for (var testDate in testDates) {
      int correctAnswersCount = 0;
      final testingItems = allTestingItems[testDate]!;

      for (int i = 0; i < testingItems.length; i++) {
        final detailsList = testingItems[i].split("_");
        final correctAnswer = detailsList[2];
        final answer = detailsList[3];

        if (i < 10) {
          correctAnswersCount += correctAnswer[0] == answer ? 1 : 0;
        } else {
          correctAnswersCount += correctAnswer == answer ? 1 : 0;
        }
      }

      testScores.add((correctAnswersCount / testingItems.length) * 100);
    }

    final needToAdd = 5 - testDates.length;
    if (needToAdd > 0) {
      for (int i = 0; i < needToAdd; i++) {
        testDates.insert(0, "");
        testScores.insert(0, 0);
      }
    }

    return {
      'dates': testDates,
      'scores': testScores,
    };
  }

  Widget buildLineChartOrText(PatientSessions? user) {
    if (user == null) {
      return Center(
        child: Text(
          "Please assign a patient to monitor their progress.",
          textAlign: TextAlign.center,
          style: darkTextTheme().headlineSmall,
        ),
      );
    }

    LineChartData? lineChartData = buildLineChartData(user, _currentType);

    return LineChart(lineChartData);
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final today = DateTime.now();
    final formatter = DateFormat('MM/dd');
    final valueInt = value.toInt();

    const style = TextStyle(
      fontFamily: 'Sailec Medium',
      fontSize: 8,
      color: Colors.white,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(formatter.format(today.subtract(Duration(days: 4 - valueInt))), style: style),
    );
  }

  LineChartData buildLineChartData(PatientSessions user, String type) {
    List<FlSpot> dataPoints = [];
    Widget Function(double, TitleMeta) getTitlesWidget = bottomTitles;

    if (type == availableTypes[0]) {
      final List<double> activityPercentages = getActivityPercentagesFromLastFiveDays();

      for (int i = 0; i < activityPercentages.length; i++) {
        dataPoints.add(FlSpot(i.toDouble(), activityPercentages[i]));
      }
    } else {
      final testDatesMap = getTestScoresFromLastFiveTests();
      final datesStringList = testDatesMap['dates'];
      final scoresList = testDatesMap['scores'];

      Widget customBottomTitles(double value, TitleMeta meta) {
        final valueInt = value.toInt();

        const style = TextStyle(
          fontFamily: 'Sailec Medium',
          fontSize: 8,
          color: Colors.white,
        );

        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(datesStringList![valueInt], style: style),
        );
      }

      getTitlesWidget = customBottomTitles;

      for (int i = 0; i < scoresList!.length; i++) {
        dataPoints.add(FlSpot(i.toDouble(), scoresList[i]));
      }
    }

    return LineChartData(
      backgroundColor: const Color(0xff275492),
      minY: 0,
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
            interval: 1.0,
            reservedSize: 20,
            showTitles: true,
            getTitlesWidget: getTitlesWidget,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: dataPoints,
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
}
