import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/testing_item.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class ResultsData {
  final AppUser user;
  final Session currentSession;
  final double score;
  final bool isPretest;
  final List<TestingItem> items;

  ResultsData({required this.user, required this.currentSession, required this.score, required this.isPretest, required this.items});
}
