import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseModel {
  final String id;
  final String name;
  final int value;
  // Include other fields that represent the structure of your Firestore documents

  FireBaseModel({required this.id, required this.name, required this.value});

  // A factory constructor for creating a new MyModel instance from a Firestore document.
  factory FireBaseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FireBaseModel(
      id: doc.id,
      name: data['name'],
      value: data['value'],
      // Initialize other fields from the data map
    );
  }
}
