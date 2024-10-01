import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/enums/standard_therapy_enums.dart';

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
      'dailyActivities': [],
      'testingItems': [],
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

  List<bool> getSessionConditions() {
    // return [
    //   pretestScore != null,
    //   isStandardOneDone,
    //   isPassiveDone,
    //   isStandardTwoDone,
    //   posttestScore != null,
    // ];
    return [false, false, false, false, false];
  }

  double getSessionPercentCompletion() {
    final List<bool> conditions = getSessionConditions();
    return conditions.where((condition) => condition == true).length * (100 / conditions.length);
  }

  StandardTherapy getStandardOneType() {
    // return stringToStandardTherapyEnum(standardOneType);
    return StandardTherapy.pod;
  }

  StandardTherapy getStandardTwoType() {
    // return stringToStandardTherapyEnum(standardTwoType);
    return StandardTherapy.pod;
  }
}
