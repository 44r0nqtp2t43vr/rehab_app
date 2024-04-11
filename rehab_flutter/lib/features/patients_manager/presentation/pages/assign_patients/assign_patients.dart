import 'package:flutter/material.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';

class AssignPatients extends StatefulWidget {
  final String physicianId;

  const AssignPatients({super.key, required this.physicianId});

  @override
  State<AssignPatients> createState() => _AssignPatientsState();
}

class _AssignPatientsState extends State<AssignPatients> {
  final TextEditingController _patientIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            TextField(
              controller: _patientIdController,
              decoration: customInputDecoration.copyWith(
                labelText: 'Patient ID',
                hintText: 'Enter ID of patient to assign',
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
