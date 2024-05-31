import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class StandardData {
  final AppUser user;
  final Session currentSession;
  final bool isStandardOne;

  StandardData({required this.user, required this.currentSession, required this.isStandardOne});
}
