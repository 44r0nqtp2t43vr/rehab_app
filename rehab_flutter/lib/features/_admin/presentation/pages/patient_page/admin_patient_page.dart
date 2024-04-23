import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_bloc.dart';
import 'package:rehab_flutter/features/_admin/presentation/bloc/viewed_patient/viewed_patient_state.dart';
import 'package:rehab_flutter/features/_admin/presentation/pages/patient_page/admin_patient_content.dart';

class AdminPatientPage extends StatelessWidget {
  const AdminPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ViewedPatientBloc, ViewedPatientState>(
          builder: (context, state) {
            if (state is ViewedPatientLoading) {
              return const Center(child: CupertinoActivityIndicator(color: Colors.white));
            }
            if (state is ViewedPatientDone) {
              return AdminPatientContent(patient: state.patient!);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
