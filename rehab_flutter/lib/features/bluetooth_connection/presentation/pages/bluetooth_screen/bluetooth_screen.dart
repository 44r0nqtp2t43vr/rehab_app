import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as flutter_blue_plus;
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_state.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/service_screen/service_screen.dart';
import 'package:rehab_flutter/injection_container.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  BluetoothScreenState createState() => BluetoothScreenState();
}

class BluetoothScreenState extends State<BluetoothScreen> {
  void selectDevice(flutter_blue_plus.BluetoothDevice device) async {
    await sl<BluetoothController>().connectToDevice(device);
    sl<BluetoothController>().targetDevice = device; // Store the connected device
    await sl<BluetoothController>().discoverServices(device).then((services) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ServiceScreen(services: services))));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    sl<BluetoothController>().stopScan();
    sl<BluetoothController>().disconnectDevice();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BluetoothBloc>()..add(const ScanDevicesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select a Bluetooth Device'),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<BluetoothBloc, BluetoothState>(
      builder: (context, state) {
        if (state is BluetoothLoading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is BluetoothDone) {
          return ListView.builder(
            itemCount: state.devices!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.devices![index].platformName.isEmpty ? 'Unknown Device' : state.devices![index].platformName),
                subtitle: Text(state.devices![index].remoteId.toString()),
                onTap: () => selectDevice(state.devices![index]),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
