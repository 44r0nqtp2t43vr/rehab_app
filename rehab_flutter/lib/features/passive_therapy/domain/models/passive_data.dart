import 'package:rehab_flutter/core/entities/session.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class PassiveData {
  final AppUser user;
  final Session currentSession;

  PassiveData({
    required this.user,
    required this.currentSession,
  });
}
