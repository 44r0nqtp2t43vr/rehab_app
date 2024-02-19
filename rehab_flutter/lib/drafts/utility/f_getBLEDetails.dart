import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
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
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name == "Gloves_BLE_01") {
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
          title: Text("Connect to Gloves_BLE_01"),
          content: Text("Do you want to connect?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
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
        title: Text('Bluetooth Device Services'),
      ),
      body: isScanning
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text('Service UUID: ${services[index].uuid}'),
                  children:
                      services[index].characteristics.map((characteristic) {
                    return ListTile(
                      title:
                          Text('Characteristic UUID: ${characteristic.uuid}'),
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
