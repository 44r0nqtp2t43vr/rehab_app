import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final String sessionId;
  final DateTime date;

  // Standard 1
  final String standardOneType;
  final String standardOneIntensity;
  final bool isStandardOneDone;

  // Passive
  final String passiveIntensity;
  final bool isPassiveDone;

  // Standard 2
  final String standardTwoType;
  final String standardTwoIntensity;
  final bool isStandardTwoDone;

  // Tests
  final double? pretestScore;
  final double? posttestScore;

  const Session({
    required this.sessionId,
    required this.date,
    required this.standardOneType,
    required this.standardOneIntensity,
    required this.isStandardOneDone,
    required this.passiveIntensity,
    required this.isPassiveDone,
    required this.standardTwoType,
    required this.standardTwoIntensity,
    required this.isStandardTwoDone,
    this.pretestScore,
    this.posttestScore,
  });

  // Static method to create a Session object with default values
  static Session empty() {
    return Session(
      sessionId: '',
      date: DateTime.now(),
      standardOneType: '',
      standardOneIntensity: '',
      isStandardOneDone: false,
      passiveIntensity: '',
      isPassiveDone: false,
      standardTwoType: '',
      standardTwoIntensity: '',
      isStandardTwoDone: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'date': date,
      'standardOneType': standardOneType,
      'standardOneIntensity': standardOneIntensity,
      'isStandardOneDone': isStandardOneDone,
      'passiveIntensity': passiveIntensity,
      'isPassiveDone': isPassiveDone,
      'standardTwoType': standardTwoType,
      'standardTwoIntensity': standardTwoIntensity,
      'isStandardTwoDone': isStandardTwoDone,
      'pretestScore': pretestScore,
      'posttestScore': posttestScore,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      sessionId: map['sessionId'],
      date: (map['date'] as Timestamp).toDate(),
      standardOneType: map['standardOneType'],
      standardOneIntensity: map['standardOneIntensity'],
      isStandardOneDone: map['isStandardOneDone'],
      passiveIntensity: map['passiveIntensity'],
      isPassiveDone: map['isPassiveDone'],
      standardTwoType: map['standardTwoType'],
      standardTwoIntensity: map['standardTwoIntensity'],
      isStandardTwoDone: map['isStandardTwoDone'],
      pretestScore: map['pretestScore'],
      posttestScore: map['posttestScore'],
    );
  }

  List<bool> getSessionConditions() {
    return [
      pretestScore != null,
      isStandardOneDone,
      isPassiveDone,
      isStandardTwoDone,
      posttestScore != null,
    ];
  }
}
// Session Provider
// Sessions are categorized by 1, 2, 3, 4, and 5
// 1 is each standard therapy is 1 and the passive therapy is 4 minutes
// 2 is one standard therapy is 1, the other standard therapy is 2 and the passive therapy is 8 minutes
// 3 is each standard therapy is medium and the passive therapy is 12 minutes
// 4 is one medium, one hard standard therapy and the passive therapy is 16 minutes
// 5 is each standard therapy is hard and the passive therapy is 20 minutes
// Each session is determined by the pretest.
// The pretest is a score from 0 to 100.
// if pretest is 0 to 20, the session is easy
// if pretest is 21 to 40, the session is easy-medium
// if pretest is 41 to 60, the session is medium
// if pretest is 61 to 80, the session is medium-hard
// if pretest is 81 to 100, the session is hard