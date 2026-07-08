import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class ResultsData {
  final AppUser user;
  final Session currentSession;
  final List<String> items;

  ResultsData({required this.user, required this.currentSession, required this.items});
}
