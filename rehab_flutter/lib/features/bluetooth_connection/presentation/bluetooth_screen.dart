import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart'; // Adjust the import path as necessary
import 'package:rehab_flutter/features/bluetooth_connection/presentation/service_screen.dart';
import 'package:rehab_flutter/screens/menu_screen.dart';

import '../../../injection_container.dart'; // Adjust the import path as necessary

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final BluetoothController bluetoothController = BluetoothController();
  List<BluetoothDevice> devicesList = [];
  bool isScanning = false;
  BluetoothDevice? connectedDevice; // Variable to store the connected device

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  void getDevices() {
    setState(() {
      isScanning = true;
    });
    bluetoothController.startScan(
        onDevicesDiscovered: (List<BluetoothDevice> devices) {
      setState(() {
        devicesList = devices;
        isScanning = false;
      });
    });
  }

  void selectDevice(BluetoothDevice device) async {
    await bluetoothController.connectToDevice(device);
    connectedDevice = device; // Store the connected device
    var services = await bluetoothController.discoverServices(device);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ServiceScreen(services: services)));
  }

  @override
  Widget build(BuildContext context) {
    // Filter the devicesList to only include devices with 'Gloves' in their name
    var filteredDevicesList =
        devicesList.where((device) => device.name.contains('Gloves')).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Bluetooth Device'),
      ),
      body: isScanning
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredDevicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredDevicesList[index].name.isEmpty
                      ? 'Unknown Device'
                      : filteredDevicesList[index].name),
                  subtitle: Text(filteredDevicesList[index].id.toString()),
                  onTap: () => selectDevice(filteredDevicesList[index]),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    bluetoothController.stopScan();
    if (connectedDevice != null) {
      bluetoothController.disconnectDevice(connectedDevice!); // Disconnect
    }
    super.dispose();
  }
}
