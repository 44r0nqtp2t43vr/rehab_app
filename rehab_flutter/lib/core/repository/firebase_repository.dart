import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rehab_flutter/core/interface/firebase_repository.dart';
import 'package:rehab_flutter/features/login_register/domain/entities/register_data.dart';

class FirestoreRepositoryImpl implements FirebaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> registerUser(RegisterData data) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );
  }

  // @override
  // Future<void> addNewDocument(Map<String, dynamic> data) async {
  //   await _firestore.collection('yourCollection').add(data);
  // }

  // @override
  // Stream<List<FireBaseModel>> streamDocuments() {
  //   return _firestore.collection('yourCollection').snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => FireBaseModel.fromFirestore(doc)).toList();
  //   });
  // }

  // Implement other methods
}
