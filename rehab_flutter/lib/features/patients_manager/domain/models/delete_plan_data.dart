import 'package:rehab_flutter/core/entities/user.dart';

class DeletePlanData {
  final AppUser user;
  final String planIdToDelete;

  const DeletePlanData({
    required this.user,
    required this.planIdToDelete,
  });
}
