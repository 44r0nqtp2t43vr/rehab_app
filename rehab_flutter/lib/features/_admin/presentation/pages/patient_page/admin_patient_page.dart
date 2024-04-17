import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/entities/user.dart';

class AdminPatientPage extends StatelessWidget {
  final AppUser patient;

  const AdminPatientPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(patient.userId)));
  }
}
