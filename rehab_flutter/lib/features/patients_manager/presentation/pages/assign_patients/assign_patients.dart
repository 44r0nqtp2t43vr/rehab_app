import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/entities/physician.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/features/patients_manager/domain/models/assign_patient_data.dart';
import 'package:rehab_flutter/injection_container.dart';

class AssignPatients extends StatefulWidget {
  const AssignPatients({super.key});

  @override
  State<AssignPatients> createState() => _AssignPatientsState();
}

class _AssignPatientsState extends State<AssignPatients> {
  MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  bool fromError = false;

  @override
  void initState() {
    _scannerController.start();
    super.initState();
  }

  @override
  void dispose() {
    _scannerController.dispose(); // Dispose the scanner controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhysicianBloc, PhysicianState>(
      listener: (context, state) {
        if (state is PhysicianNone) {
          setState(() {
            fromError = true;
            _scannerController = MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
            );
          });

          BlocProvider.of<PhysicianBloc>(context).add(GetPhysicianEvent(state.data));
        }
        if (state is PhysicianDone && !fromError) {
          sl<NavigationController>().setTab(TabEnum.activityMonitor);
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is PhysicianLoading) {
          return const Scaffold(body: Center(child: CupertinoActivityIndicator(color: Colors.white)));
        }
        if (state is PhysicianDone) {
          return Scaffold(
            body: MobileScanner(
              controller: _scannerController,
              onDetect: (capture) => _onDetect(
                context,
                capture,
                state.currentPhysician!,
              ),
            ),
          );
        }
        return const Scaffold();
      },
    );
  }

  void _onDetect(BuildContext context, BarcodeCapture capture, Physician physician) {
    final barcodes = capture.barcodes;

    setState(() {
      fromError = false;
    });

    if (barcodes.isNotEmpty) {
      _scannerController.dispose();

      BlocProvider.of<PhysicianBloc>(context).add(AssignPatientEvent(AssignPatientData(
        physician: physician,
        patientId: barcodes.first.rawValue!,
      )));
    }
  }
}
