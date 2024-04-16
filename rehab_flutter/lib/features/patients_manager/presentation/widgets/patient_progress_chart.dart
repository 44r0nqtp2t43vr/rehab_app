import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/patients_manager/domain/enums/patient_progress_type.dart';

class PatientProgressChart extends StatefulWidget {
  final List<AppUser> patients;

  const PatientProgressChart({super.key, required this.patients});

  @override
  State<PatientProgressChart> createState() => _PatientProgressChartState();
}

class _PatientProgressChartState extends State<PatientProgressChart> {
  final List<String> _availableTypes = availableTypes;
  late String _currentType;
  AppUser? _patient;

  void _onTypeDropdownSelect(String? newValue) {
    setState(() {
      _currentType = newValue!;
    });
  }

  void _onPatientDropdownSelect(AppUser? newValue) {
    setState(() {
      _patient = newValue!;
    });
  }

  @override
  void initState() {
    _patient = widget.patients.isNotEmpty ? widget.patients[0] : null;
    _currentType = availableTypes[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.white),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
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
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _currentType,
          decoration: customInputDecoration.copyWith(
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
        const SizedBox(height: 8),
        DropdownButtonFormField<AppUser>(
          value: _patient,
          decoration: customInputDecoration.copyWith(
            labelText: 'Patient',
          ),
          onChanged: _onPatientDropdownSelect,
          items: widget.patients.map<DropdownMenuItem<AppUser>>((AppUser patient) {
            return DropdownMenuItem<AppUser>(
              value: patient,
              child: Text(patient.getUserFullName()),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildLineChartOrText(AppUser? user) {
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

  LineChartData buildLineChartData(AppUser user, String type) {
    List<FlSpot> dataPoints = [];
    List<Session> allSessions = user.getAllSessionsFromAllPlans();
    final DateTime today = DateTime.now();

    if (type == availableTypes[0]) {
      List<double> previousPostTestScores = [0, 0, 0, 0, 0];

      for (int i = 0; i < 5; i++) {
        DateTime date = today.subtract(Duration(days: i));
        Session? session = allSessions.firstWhere(
          (session) => session.date.year == date.year && session.date.month == date.month && session.date.day == date.day,
          orElse: () => Session.empty(),
        );

        if (session.posttestScore != null) {
          previousPostTestScores[4 - i] = session.posttestScore!;
        } else {
          previousPostTestScores[4 - i] = 0;
        }
      }

      double currentPostTestScore = user.getCurrentSession()?.posttestScore ?? 0;
      previousPostTestScores[4] = currentPostTestScore;

      for (int i = 0; i < previousPostTestScores.length; i++) {
        dataPoints.add(FlSpot(i.toDouble(), previousPostTestScores[i]));
      }
    } else {
      List<double> previousProgressScores = [0, 0, 0, 0, 0];

      for (int i = 0; i < 5; i++) {
        DateTime date = today.subtract(Duration(days: i));
        Session? session = allSessions.firstWhere(
          (session) => session.date.year == date.year && session.date.month == date.month && session.date.day == date.day,
          orElse: () => Session.empty(),
        );

        if (session.sessionId.isNotEmpty) {
          previousProgressScores[4 - i] = session.getSessionPercentCompletion();
        } else {
          previousProgressScores[4 - i] = 0;
        }

        dataPoints.add(FlSpot(i.toDouble(), previousProgressScores[i]));
      }
    }

    return LineChartData(
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
            getTitlesWidget: bottomTitles,
          ),
        ),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: dataPoints,
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
}
