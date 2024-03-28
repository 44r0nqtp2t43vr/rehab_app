import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/injection_container.dart';

class BluetoothConnectScreen extends StatelessWidget {
  const BluetoothConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 120,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 35,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.chevron_right,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () => _onSkip(context),
            ),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF01FF99),
                    Color(0xFF128BED),
                    Color(0xFF16478B),
                  ],
                  stops: [0.0, 0.8, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onBlueToothScreenTap(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Connect to CU.TOUCH Gloves',
                            style: darkTextTheme().headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            'via Bluetooth',
                            style: darkTextTheme().headlineSmall,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/bluetooth-screen-1.png',
                                width: 300,
                                height: 250,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Tap the screen to set up your gloves.',
                                style: darkTextTheme().headlineSmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBlueToothScreenTap(BuildContext context) {
    Navigator.pushNamed(context, '/BluetoothScreen');
  }

  void _onSkip(BuildContext context) {
    sl<NavigationController>().setTab(TabEnum.home);
    Navigator.pushNamed(context, '/MainScreen');
  }
}
