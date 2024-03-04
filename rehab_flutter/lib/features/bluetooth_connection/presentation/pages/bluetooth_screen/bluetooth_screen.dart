import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/features/bluetooth_connection/presentation/pages/service_screen/service_screen.dart';
import 'package:rehab_flutter/injection_container.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  BluetoothScreenState createState() => BluetoothScreenState();
}

class BluetoothScreenState extends State<BluetoothScreen> {
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
    bluetoothController.startScan(onDevicesDiscovered: (List<BluetoothDevice> devices) {
      setState(() {
        devicesList = devices;
        isScanning = false;
      });
    });
  }

  void selectDevice(BluetoothDevice device) async {
    await bluetoothController.connectToDevice(device);
    connectedDevice = device; // Store the connected device
    await bluetoothController.discoverServices(device).then((services) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ServiceScreen(services: services))));
  }

  @override
  Widget build(BuildContext context) {
    // Filter the devicesList to only include devices with 'Gloves' in their name
    var filteredDevicesList = devicesList.where((device) => device.platformName.contains('Gloves')).toList();

    return BlocProvider(
      create: (_) => sl<BluetoothBloc>()
        ..add(InitActuatorsEvent(ActuatorsInitData(
          imgSrc: imageTextureProvider.imageTextures[0].texture,
          orientation: ActuatorsOrientation.landscape,
          numOfFingers: ActuatorsNumOfFingers.one,
          imagesHeight: 0,
          imagesWidth: 0,
        ))),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select a Bluetooth Device'),
        ),
        body: isScanning
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: filteredDevicesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredDevicesList[index].platformName.isEmpty ? 'Unknown Device' : filteredDevicesList[index].platformName),
                    subtitle: Text(filteredDevicesList[index].remoteId.toString()),
                    onTap: () => selectDevice(filteredDevicesList[index]),
                  );
                },
              ),
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
