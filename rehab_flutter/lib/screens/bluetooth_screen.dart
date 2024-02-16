import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rehab_flutter/controller/bluetooth_controller.dart'; // Adjust the import path as necessary
import 'package:rehab_flutter/screens/menu_screen.dart'; // Adjust the import path as necessary

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Bluetooth Device'),
      ),
      body: isScanning
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devicesList[index].name.isEmpty
                      ? 'Unknown Device'
                      : devicesList[index].name),
                  subtitle: Text(devicesList[index].id.toString()),
                  onTap: () => selectDevice(devicesList[index]),
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

class ServiceScreen extends StatelessWidget {
  final List<BluetoothService> services;

  const ServiceScreen({Key? key, required this.services}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Services'),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text('Service UUID: ${services[index].uuid}'),
            children: services[index]
                .characteristics
                .map((BluetoothCharacteristic characteristic) {
              return ListTile(
                title: Text('Characteristic UUID: ${characteristic.uuid}'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MenuScreen(targetCharacteristic: characteristic),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
