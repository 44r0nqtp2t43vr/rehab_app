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
}
