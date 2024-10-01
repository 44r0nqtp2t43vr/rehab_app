import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';
import 'package:rehab_flutter/core/resources/formatters.dart';

class Session {
  String sessionId;
  DateTime endDate;
  List<String> dailyActivities;
  List<String> testingItems;

  Session({
    required this.sessionId,
    required this.endDate,
    required this.dailyActivities,
    required this.testingItems,
  });

  // Static method to create a Session object with default values
  static Session empty() {
    return Session(
      sessionId: '',
      endDate: DateTime.now(),
      dailyActivities: [],
      testingItems: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'endDate': endDate,
      'dailyActivities': dailyActivities,
      'testingItems': testingItems,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      sessionId: map['sessionId'],
      endDate: (map['endDate'] as Timestamp).toDate(),
      dailyActivities: List<String>.from(map['dailyActivities'] ?? []),
      testingItems: List<String>.from(map['testingItems'] ?? []),
    );
  }

  String? getTodayActivities() {
    final todayString = formatDateMMDDYYYY(DateTime.now());
    final todayActivities = dailyActivities.firstWhere((daString) => daString.startsWith(todayString), orElse: () => "");
    return todayActivities.isEmpty ? null : todayActivities;
  }

  List<bool> getSessionConditions(String dayActivities) {
    if (dayActivities.isEmpty) {
      return [false, false, false];
    }

    final dayActivitiesBools = dayActivities.split('_')[3];

    return [
      dayActivitiesBools[0] == 't' ? true : false,
      dayActivitiesBools[1] == 't' ? true : false,
      dayActivitiesBools[2] == 't' ? true : false,
    ];
  }

  double getSessionPercentCompletion() {
    final List<bool> conditions = getSessionConditions("");
    return conditions.where((condition) => condition == true).length * (100 / conditions.length);
  }

  StandardTherapy getStandardOneType(String dayActivities) {
    if (dayActivities.isEmpty) {
      return StandardTherapy.pod;
    }

    final dayActivitiesStandardOne = dayActivities.split('_')[1];
    return stringToStandardTherapyEnum(dayActivitiesStandardOne.substring(0, 3));
  }

  StandardTherapy getStandardTwoType(String dayActivities) {
    if (dayActivities.isEmpty) {
      return StandardTherapy.pod;
    }

    final dayActivitiesStandardOne = dayActivities.split('_')[2];
    return stringToStandardTherapyEnum(dayActivitiesStandardOne.substring(0, 3));
  }

  int getStandardOneIntensity(String dayActivities) {
    if (dayActivities.isEmpty) {
      return 1;
    }

    final dayActivitiesStandardOne = dayActivities.split('_')[1];
    return int.parse(dayActivitiesStandardOne[3]);
  }

  int getStandardTwoIntensity(String dayActivities) {
    if (dayActivities.isEmpty) {
      return 1;
    }

    final dayActivitiesStandardOne = dayActivities.split('_')[2];
    return int.parse(dayActivitiesStandardOne[3]);
  }
}
