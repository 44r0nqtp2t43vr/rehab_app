import 'package:rehab_flutter/core/entities/user.dart';

class ResultsData {
  final AppUser user;
  final double score;
  final bool isPretest;

  ResultsData({required this.user, required this.score, required this.isPretest});
}
