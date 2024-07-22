import 'package:rehab_flutter/core/entities/plan.dart';
import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class GetTestAnalyticsData {
  final AppUser patient;
  final Plan plan;
  final Session session;
  final String testType;

  const GetTestAnalyticsData({
    required this.patient,
    required this.plan,
    required this.session,
    required this.testType,
  });
}
