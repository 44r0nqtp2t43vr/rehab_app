import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;
  final String targetDeviceName = "Gloves_BLE_01";
  bool isDeviceConnected = false;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.name == targetDeviceName) {
          print("Device found: ${result.device.name}");
          FlutterBluePlus.stopScan();
          setState(() {
            targetDevice = result.device;
          });
          connectToDevice();
          break;
        }
      }
    });
  }

  void connectToDevice() async {
    if (targetDevice != null) {
      await targetDevice!.connect();
      print("Device connected");
      setState(() {
        isDeviceConnected = true;
      });
      discoverServices();
    }
  }

  void discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice!.discoverServices();
    services.forEach((service) {
      // Match the service UUID of your device
      if (service.uuid.toString().toUpperCase() ==
          "0000FFE0-0000-1000-8000-00805F9B34FB") {
        service.characteristics.forEach((characteristic) {
          // Match the characteristic UUID for sending data
          if (characteristic.uuid.toString().toUpperCase() ==
              "0000FFE2-0000-1000-8000-00805F9B34FB") {
            targetCharacteristic = characteristic;
          }
        });
      }
    });
  }

  void sendPattern(int pattern) {
    if (targetCharacteristic == null) return;

    String data;
    if (pattern == 1) {
      data = "<000000000000000000000000>"; // Actual data for pattern 1
    } else if (pattern == 2) {
      data = "<106106106106106106106106106106>"; // Actual data for pattern 2
    } else {
      print("Invalid pattern");
      return;
    }

    targetCharacteristic!.write(data.codeUnits);
    print("Pattern $pattern sent");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth Device Connector'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (isDeviceConnected) ...[
                Text('Device Connected'),
                ElevatedButton(
                  onPressed: () => sendPattern(1),
                  child: Text('Send Pattern 1'),
                ),
                SizedBox(height: 10), // Add spacing between the buttons
                ElevatedButton(
                  onPressed: () => sendPattern(2),
                  child: Text('Send Pattern 2'),
                ),
              ] else ...[
                Text('Searching for Device...'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
