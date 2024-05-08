import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_state.dart';
import 'package:rehab_flutter/core/controller/navigation_controller.dart';
import 'package:rehab_flutter/core/enums/nav_enums.dart';
import 'package:rehab_flutter/injection_container.dart';

class ServiceScreen extends StatelessWidget {
  final BluetoothDevice targetDevice;

  const ServiceScreen({Key? key, required this.targetDevice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BluetoothBloc>()..add(ConnectDeviceEvent(targetDevice)),
      child: PopScope(
        onPopInvoked: (didPop) => sl<BluetoothBloc>().add(const DisconnectDeviceEvent()),
        child: Scaffold(
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
                _buildBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<BluetoothBloc, BluetoothAppState>(
      builder: (context, state) {
        if (state is BluetoothLoading) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        } else if (state is BluetoothDone) {
          BluetoothCharacteristic? ffe2Characteristic;
          // Search for the characteristic with UUID ffe2 across all services.
          for (var service in state.services!) {
            for (var characteristic in service.characteristics) {
              if (characteristic.uuid.toString().toUpperCase() == 'FFE2') {
                ffe2Characteristic = characteristic;
                break; // Stop searching once found
              }
            }
            if (ffe2Characteristic != null) {
              break; // Stop searching through services once found
            }
          }

          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Set up CU.TOUCH Station',
                    style: darkTextTheme().headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'CU.TOUCH Station Characteristics',
                    style: darkTextTheme().headlineSmall,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/bluetooth-screen-2.png',
                          width: 300,
                          height: 250,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ffe2Characteristic != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => _onCharacteristicButtonPressed(context, ffe2Characteristic!),
                                        style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(
                                            Colors.white,
                                          ),
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                            Colors.white.withOpacity(.3),
                                          ),
                                          elevation: MaterialStateProperty.all<double>(0),
                                          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        child: const Text('Confirm'),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                'No characteristic with UUID ffe2 found.',
                                style: darkTextTheme().headlineSmall,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  void _onCharacteristicButtonPressed(BuildContext context, BluetoothCharacteristic characteristic) {
    sl<BluetoothBloc>().add(UpdateCharaEvent(characteristic));
    sl<NavigationController>().setTab(TabEnum.home);
    Navigator.pushNamed(context, '/MainScreen');
  }
}
