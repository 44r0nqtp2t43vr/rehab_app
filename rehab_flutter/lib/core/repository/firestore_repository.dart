import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/interface/firestore_repository.dart';

class FirebaseRepository implements FirebaseInterface {
  final FirebaseFirestore db;

  FirebaseRepository(this.db);

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
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getLoginLogs() async {
    final snapshot = await db.collection('loginAttempts').get();
    return snapshot.docs;
  }
}
