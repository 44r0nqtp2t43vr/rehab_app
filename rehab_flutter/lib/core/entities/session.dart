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

  String? getDayActivities(String dayString) {
    final dayActivities = dailyActivities.firstWhere((daString) => daString.startsWith(dayString), orElse: () => "");
    return dayActivities.isEmpty ? null : dayActivities;
  }

  String? getTodayActivities() {
    final todayString = formatDateMMDDYYYY(DateTime.now());
    final todayActivities = dailyActivities.firstWhere((daString) => daString.startsWith(todayString), orElse: () => "");
    return todayActivities.isEmpty ? null : todayActivities;
  }

  int getTodayActivitiesIndex() {
    final todayString = formatDateMMDDYYYY(DateTime.now());
    return dailyActivities.indexWhere((daString) => daString.startsWith(todayString));
  }

  void updateTodayActivities(String newTodayActivities) {
    dailyActivities[getTodayActivitiesIndex()] = newTodayActivities;
  }

  void updateTodayActivitiesTherapy(bool isStandardOne, bool isPassive) {
    final todayString = formatDateMMDDYYYY(DateTime.now());
    final todayActivities = dailyActivities.firstWhere((daString) => daString.startsWith(todayString), orElse: () => "");
    final todayActivitiesIndex = dailyActivities.indexWhere((daString) => daString.startsWith(todayString));
    final todayActivitiesList = todayActivities.split('_');

    if (isStandardOne) {
      todayActivitiesList[3] = "tff";
    } else if (isPassive) {
      todayActivitiesList[3] = "ttf";
    } else {
      todayActivitiesList[3] = "ttt";
    }

    final updatedTodayActivities = todayActivitiesList.join("_");
    dailyActivities[todayActivitiesIndex] = updatedTodayActivities;
  }

  List<bool> getDayActivitiesConditions(String dayString) {
    final dayActivities = getDayActivities(dayString);

    if (dayActivities == null || dayActivities.isEmpty) {
      return [false, false, false];
    }

    final dayActivitiesBools = dayActivities.split('_')[3];

    return [
      dayActivitiesBools[0] == 't' ? true : false,
      dayActivitiesBools[1] == 't' ? true : false,
      dayActivitiesBools[2] == 't' ? true : false,
    ];
  }

  List<bool> getDayActivitiesConditionsFromDayActivities(String dayActivities) {
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

  List<bool> getTodayActivitiesConditions() {
    final todayString = formatDateMMDDYYYY(DateTime.now());
    final todayActivities = dailyActivities.firstWhere((daString) => daString.startsWith(todayString), orElse: () => "");

    if (todayActivities.isEmpty) {
      return [false, false, false];
    }

    final todayActivitiesBools = todayActivities.split('_')[3];

    return [
      todayActivitiesBools[0] == 't' ? true : false,
      todayActivitiesBools[1] == 't' ? true : false,
      todayActivitiesBools[2] == 't' ? true : false,
    ];
  }

  List<String> getDayActivitiesDetailsFromDayActivities(String dayActivities) {
    final dayActivitiesList = dayActivities.split('_');
    final standardOneString = "${dayActivitiesList[1].substring(0, 3)}-${dayActivitiesList[1][dayActivitiesList[1].length - 1]}";
    final standardTwoString = "${dayActivitiesList[2].substring(0, 3)}-${dayActivitiesList[2][dayActivitiesList[2].length - 1]}";
    final passiveString = "p-${standardOneString[standardOneString.length - 1]}";

    return [standardOneString, passiveString, standardTwoString];
  }

  double getSessionPercentCompletion() {
    double sum = 0;
    for (var dailyActivity in dailyActivities) {
      final activityBools = dailyActivity.split("_")[3];
      final tCount = activityBools.split('').where((char) => char == 't').length;

      double percentage = (tCount / activityBools.length) * 100;
      sum += percentage;
    }

    return sum / dailyActivities.length;
  }

  double getTodayActivitiesPercentCompletion() {
    final List<bool> conditions = getTodayActivitiesConditions();
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

  DateTime? getTestTakenDate() {
    if (testingItems.isEmpty) {
      return null;
    }

    return parseMMDDYYYY(testingItems[0].split("_")[0]);
  }

  double getTestScore() {
    if (testingItems.isEmpty) {
      return 0;
    }

    int correctAnswersCount = 0;
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

    return (correctAnswersCount / testingItems.length) * 100;
  }
}
