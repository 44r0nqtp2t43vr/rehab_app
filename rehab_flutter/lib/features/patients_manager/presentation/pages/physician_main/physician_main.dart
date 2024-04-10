import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/physician/physician_state.dart';

class PhysicianMainScreen extends StatelessWidget {
  const PhysicianMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<PhysicianBloc, PhysicianState>(builder: (context, state) {
      if (state is PhysicianLoading) {
        return const Center(child: CupertinoActivityIndicator(color: Colors.white));
      }
      if (state is PhysicianDone) {
        return Center(
          child: Text(
            state.currentPhysician!.physicianId,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
      return Container();
    });
  }
}
