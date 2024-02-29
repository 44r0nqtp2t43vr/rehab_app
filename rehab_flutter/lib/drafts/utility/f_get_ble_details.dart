import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  BluetoothScreenState createState() => BluetoothScreenState();
}

class BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothDevice? targetDevice;
  List<BluetoothService> services = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  void scanForDevices() async {
    setState(() {
      isScanning = true;
    });
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.platformName == "Gloves_BLE_01") {
          FlutterBluePlus.stopScan();
          setState(() {
            targetDevice = result.device;
            isScanning = false;
          });
          _showConnectDialog();
          break;
        }
      }
    });
  }

  void _showConnectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Connect to Gloves_BLE_01"),
          content: const Text("Do you want to connect?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                connectToDevice();
              },
            ),
          ],
        );
      },
    );
  }

  void connectToDevice() async {
    if (targetDevice != null) {
      await targetDevice!.connect();
      discoverServices();
    }
  }

  void discoverServices() async {
    if (targetDevice == null) return;

    services = await targetDevice!.discoverServices();
    //  for service.length
    setState(() {}); // Update UI to display services
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Device Services'),
      ),
      body: isScanning
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text('Service UUID: ${services[index].uuid}'),
                  children: services[index].characteristics.map((characteristic) {
                    return ListTile(
                      title: Text('Characteristic UUID: ${characteristic.uuid}'),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    if (targetDevice != null) {
      targetDevice!.disconnect();
    }
    super.dispose();
  }
}
