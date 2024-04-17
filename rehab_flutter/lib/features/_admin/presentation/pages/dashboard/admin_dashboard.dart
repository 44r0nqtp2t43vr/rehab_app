import 'package:flutter/widgets.dart';
import 'package:rehab_flutter/core/entities/admin.dart';
import 'package:rehab_flutter/features/tab_home/presentation/widgets/welcome_card.dart';

class AdminDashboard extends StatelessWidget {
  final Admin currentAdmin;

  const AdminDashboard({super.key, required this.currentAdmin});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Column(
            children: [
              const WelcomeCard(userFirstName: "Admin"),
              const SizedBox(height: 20),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
