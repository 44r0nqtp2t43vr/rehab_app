class Session {
  final String sessionId;
  final String planId;
  final DateTime date;
  final String activityOneType;
  final String activityOneSpeed;
  final int activityOneTime;
  final int activityOneCurrentTime;
  final String activityTwoIntensity;
  final int activityTwoCurrentTime;
  final String activityThreeType;
  final String activityThreeSpeed;
  final int activityThreeTime;
  final int activityThreeCurrentTime;
  final double? pretestScore;
  final double? posttestScore;

  Session({
    required this.sessionId,
    required this.planId,
    required this.date,
    required this.activityOneType,
    required this.activityOneSpeed,
    required this.activityOneTime,
    required this.activityOneCurrentTime,
    required this.activityTwoIntensity,
    required this.activityTwoCurrentTime,
    required this.activityThreeType,
    required this.activityThreeSpeed,
    required this.activityThreeTime,
    required this.activityThreeCurrentTime,
    this.pretestScore,
    this.posttestScore,
  });

  // Static method to create a Session object with default values
  static Session empty() {
    return Session(
      sessionId: '',
      planId: '',
      date: DateTime(0),
      activityOneType: '',
      activityOneSpeed: '',
      activityOneTime: 1,
      activityOneCurrentTime: 0,
      activityTwoIntensity: '',
      activityTwoCurrentTime: 0,
      activityThreeType: '',
      activityThreeSpeed: '',
      activityThreeTime: 1,
      activityThreeCurrentTime: 0,
    );
  }
}
