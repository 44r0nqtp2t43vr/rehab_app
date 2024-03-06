import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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
          appBar: AppBar(
            title: const Text('Device Services'),
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<BluetoothBloc, BluetoothAppState>(
      builder: (context, state) {
        if (state is BluetoothLoading) {
          return const Center(child: CupertinoActivityIndicator());
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

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bluetooth_connected,
                  size: 100.0,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20), // Adds space between the icon and the button
                ffe2Characteristic != null
                    ? ElevatedButton(
                        onPressed: () => _onCharacteristicButtonPressed(context, ffe2Characteristic!),
                        child: Text('Connect to Characteristic UUID: ${ffe2Characteristic.uuid}'),
                      )
                    : const Text('No characteristic with UUID ffe2 found.'),
              ],
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
