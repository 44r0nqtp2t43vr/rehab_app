import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';

abstract class FirebaseRepository {
  Future<void> logLoginAttempt(String email, bool success);
  Future<void> logLogoutAttempt(String email, bool success);
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getLoginLogs();
  Future<void> registerUser(RegisterData data);
}
