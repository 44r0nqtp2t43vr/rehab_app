class EditSessionData {
  final String userId;
  final String planId;
  final String sessionId;
  final List<String> newDailyActivities;

  const EditSessionData({
    required this.userId,
    required this.planId,
    required this.sessionId,
    required this.newDailyActivities,
  });
}
