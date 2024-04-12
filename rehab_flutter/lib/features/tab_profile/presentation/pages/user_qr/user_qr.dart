import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_bloc.dart';
import 'package:rehab_flutter/core/bloc/firebase/user/user_state.dart';

class UserQR extends StatelessWidget {
  const UserQR({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Scaffold(body: Center(child: CupertinoActivityIndicator(color: Colors.white)));
        }
        if (state is UserDone) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: PrettyQrView.data(data: state.currentUser!.userId),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
