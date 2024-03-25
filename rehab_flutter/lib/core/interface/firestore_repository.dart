import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/entities/user.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/login_data.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';
import 'package:rehab_flutter/features/plan_selection/presentation/add_plan_data.dart';
import 'package:rehab_flutter/features/pre_test_dummy/pretest_session_generation_data.dart';

abstract class FirebaseRepository {
  Future<void> logLoginAttempt(String email, bool success);
  Future<void> logLogoutAttempt(String email, bool success);
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getLoginLogs();
  Future<void> registerUser(RegisterData data);
  Future<void> addPlan(AddPlanData data);
  Future<void> submitPretest(PretestData data);
  Future<AppUser> loginUser(LoginData data);
}
