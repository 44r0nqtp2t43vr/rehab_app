import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/injection_container.dart';

class AssignPatients extends StatefulWidget {
  const AssignPatients({super.key});

  @override
  State<AssignPatients> createState() => _AssignPatientsState();
}

class _AssignPatientsState extends State<AssignPatients> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: true,
  );
  String patientId = "";

  @override
  void dispose() {
    _scannerController.dispose(); // Dispose the scanner controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhysicianBloc, PhysicianState>(
      listener: (context, state) {
        if (state is PhysicianDone) {
          sl<NavigationController>().setTab(TabEnum.activityMonitor);
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is PhysicianLoading) {
          return const Scaffold(body: Center(child: CupertinoActivityIndicator(color: Colors.white)));
        }
        if (state is PhysicianDone) {
          final List<String> currentPatients = state.currentPhysician!.patients.map((user) => user.userId).toList();

          // return Scaffold(
          //   body: SingleChildScrollView(
          //     child: Column(
          //       children: [
          //         const SizedBox(height: 40),
          //         TextField(
          //           controller: _patientIdController,
          //           decoration: customInputDecoration.copyWith(
          //             labelText: 'Patient ID',
          //             hintText: 'Enter ID of patient to assign',
          //           ),
          //         ),
          //         ElevatedButton(
          //           onPressed: () => _onAssignButtonPressed(context, state.currentPhysician!.physicianId, currentPatients),
          //           child: const Text("Submit"),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
          return Scaffold(
            body: MobileScanner(
              controller: _scannerController,
              onDetect: (capture) {
                final barcodes = capture.barcodes;
                final image = capture.image;
                if (barcodes.isNotEmpty) {
                  final barcode = barcodes.first;
                  print(barcode.rawValue);

                  // Stop the scanner
                  _scannerController.stop();

                  // Show dialog with the detected barcode
                  if (image != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(barcode.rawValue ?? ""),
                          content: Image(
                            image: MemoryImage(image),
                          ),
                        );
                      },
                    ).then((value) => _scannerController.start());
                  }
                }
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  void _onAssignButtonPressed(BuildContext context, String physicianId, List<String> patients) {
    if (!patients.contains(patientId)) {
      BlocProvider.of<PhysicianBloc>(context).add(AssignPatientEvent(AssignPatientData(
        physicianId: physicianId,
        patientId: patientId,
        patients: patients,
      )));
    }
  }
}
