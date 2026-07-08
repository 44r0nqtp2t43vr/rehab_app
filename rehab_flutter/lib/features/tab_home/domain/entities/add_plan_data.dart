import 'package:rehab_flutter/core/entities/user.dart';

class AddPlanData {
  final AppUser user;
  final int planSelected;
  final DateTime startDate;

  AddPlanData({required this.user, required this.planSelected, required this.startDate});
}
