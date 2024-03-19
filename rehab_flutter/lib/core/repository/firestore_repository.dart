import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseFirestore db;

  FirebaseRepositoryImpl(this.db);

  @override
  Future<void> logLoginAttempt(String email, bool success) async {
    await db.collection('loginAttempts').add({
      'email': email,
      'success': success,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> logLogoutAttempt(String email, bool success) async {
    await db.collection('logoutAttempts').add({
      'email': email,
      'success': success,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getLoginLogs() async {
    final snapshot = await db.collection('loginAttempts').get();
    return snapshot.docs;
  }

  @override
  Future<void> registerUser(RegisterData data) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );
  }
}
