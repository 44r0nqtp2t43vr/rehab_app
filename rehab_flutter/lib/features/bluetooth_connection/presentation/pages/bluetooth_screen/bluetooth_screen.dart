import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_state.dart';
import 'package:rehab_flutter/injection_container.dart';

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BluetoothBloc>()..add(const ScanDevicesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select a Bluetooth Device'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _onRescan(),
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<BluetoothBloc, BluetoothAppState>(
      builder: (context, state) {
        if (state is BluetoothLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is BluetoothDone) {
          return StreamBuilder<List<ScanResult>>(
            stream: state.scanResults,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Stream has data
                final scanResults = snapshot.data!.where((scanResult) => scanResult.device.platformName.contains('Gloves')).toList();
                if (scanResults.isNotEmpty) {
                  return ListView.builder(
                    itemCount: scanResults.length,
                    itemBuilder: (context, index) {
                      final device = scanResults[index].device;
                      return ListTile(
                        title: Text(device.platformName.isEmpty ? 'Unknown Device' : device.platformName),
                        subtitle: Text(device.remoteId.toString()),
                        onTap: () => _onDeviceCardPressed(context, device),
                      );
                    },
                  );
                }
              }
              return const Center(child: CupertinoActivityIndicator());
            },
          );
        }
        return Container();
      },
    );
  }

  void _onDeviceCardPressed(BuildContext context, BluetoothDevice targetDevice) {
    Navigator.pushNamed(context, '/ServiceScreen', arguments: targetDevice);
  }

  void _onRescan() {
    sl<BluetoothBloc>().add(const ScanDevicesEvent());
  }
}
