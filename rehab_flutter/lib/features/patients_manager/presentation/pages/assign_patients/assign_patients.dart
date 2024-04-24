import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_event.dart';
import 'package:rehab_flutter/core/bloc/firebase/therapist/therapist_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/entities/therapist.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
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
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double squareSize = screenWidth * 0.6;

    return BlocConsumer<TherapistBloc, TherapistState>(
      listener: (context, state) {
        if (state is TherapistNone) {
          setState(() {
            fromError = true;
            _scannerController = MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
            );
          });

          BlocProvider.of<TherapistBloc>(context).add(GetTherapistEvent(state.data));
        }
        if (state is TherapistDone && !fromError) {
          sl<NavigationController>().setTab(TabEnum.patients);
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is TherapistLoading) {
          return Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lotties/uploading.json',
                width: 400,
                height: 400,
              ),
              //CupertinoActivityIndicator(color: Colors.white),
            ),
          );
        }
        if (state is TherapistDone) {
          return Scaffold(
            body: Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  scanWindow: Rect.fromCenter(
                    center: Offset(
                      MediaQuery.of(context).size.width / 2,
                      MediaQuery.of(context).size.height / 2,
                    ),
                    width: squareSize - 4,
                    height: squareSize - 4,
                  ),
                  overlay: Container(
                    color: Colors.transparent,
                    child: CustomPaint(
                      size: MediaQuery.of(context).size,
                      painter: OverlayPainter(
                        scanWindow: Rect.fromCenter(
                          center: Offset(
                            MediaQuery.of(context).size.width / 2,
                            MediaQuery.of(context).size.height / 2,
                          ),
                          width: squareSize - 4,
                          height: squareSize - 4,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: squareSize,
                          height: squareSize,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onDetect: (capture) => _onDetect(
                    context,
                    capture,
                    state.currentTherapist!,
                  ),
                ),
                GlassContainer(
                  shadowStrength: 2,
                  shadowColor: Colors.black,
                  blur: 4,
                  color: Colors.white.withOpacity(0.50),
                  child: const Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('ss'),
                  ),
                ),
              ],
            ),
          );
        }
        return const Scaffold();
      },
    );
  }

  void _onDetect(BuildContext context, BarcodeCapture capture, Therapist therapist) {
    final barcodes = capture.barcodes;

    setState(() {
      fromError = false;
    });

    if (barcodes.isNotEmpty) {
      _scannerController.dispose();

      // TODO: update implementation
      // BlocProvider.of<TherapistBloc>(context).add(AssignPatientEvent(AssignPatientData(
      //   therapist: therapist,
      //   patientId: barcodes.first.rawValue!,
      // )));
    }
  }
}

class OverlayPainter extends CustomPainter {
  final Rect scanWindow;

  OverlayPainter({required this.scanWindow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final scanWindowPath = Path()..addRect(scanWindow);

    final overlayPath = Path.combine(PathOperation.difference, backgroundPath, scanWindowPath);

    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
