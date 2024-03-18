import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rehab_flutter/core/entities/firebase_model.dart';
import 'package:rehab_flutter/core/interface/firebase_repository.dart';

class FirestoreDatabaseRepository implements DatabaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> addNewDocument(Map<String, dynamic> data) async {
    await _firestore.collection('yourCollection').add(data);
  }

  @override
  Stream<List<FireBaseModel>> streamDocuments() {
    return _firestore.collection('yourCollection').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FireBaseModel.fromFirestore(doc))
          .toList();
    });
  }

  // Implement other methods
}
