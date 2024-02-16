import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;
  final String targetDeviceName = "Gloves_BLE_01";
  bool isDeviceConnected = false;

  // This will keep track of the total value for the simulated single module
  int moduleValue = 0;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult result in results) {
        print(result.device.name);
        if (result.device.name == targetDeviceName) {
          print("Device found: ${result.device.name}");
          flutterBlue.stopScan();
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
    for (BluetoothService service in services) {
      // Here you might check the service.uuid against known UUIDs or criteria
      // For demonstration, let's assume we're looking for a specific UUID or part of it
      var serviceUUID = service.uuid.toString().toUpperCase();
      if (serviceUUID.contains("0000FFE0-0000-1000-8000-00805F9B34FB")) {
        // Replace with actual partial or full UUID
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          var characteristicUUID = characteristic.uuid.toString().toUpperCase();
          // Similarly, check if this is the characteristic we're interested in
          if (characteristicUUID
              .contains("0000FFE2-0000-1000-8000-00805F9B34FB")) {
            // Replace with actual partial or full UUID
            setState(() {
              targetCharacteristic =
                  characteristic; // Store the characteristic for later use
            });
            return; // Exit if the desired characteristic is found
          }
        }
      }
    }

    if (targetCharacteristic == null) {
      print("Desired service/characteristic not found");
    }
  }

  void updateModuleValue(int valueToAdd) {
    setState(() {
      moduleValue =
          (moduleValue + valueToAdd) % 256; // Ensure value does not exceed 255
      sendPattern();
    });
  }

  void sendPattern() {
    if (targetCharacteristic == null) return;

    // Generate the string for 10 modules
    String moduleValueString = moduleValue.toString().padLeft(3, '0');
    String data = "<" + List.filled(10, moduleValueString).join() + ">";

    targetCharacteristic!.write(data.codeUnits);
    print("Pattern sent: $data");
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
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    // Define buttons for values 1, 2, 4, 8, 16, 32, 64, 128
                    for (int value in [1, 2, 4, 8, 16, 32, 64, 128])
                      ElevatedButton(
                        onPressed: () => updateModuleValue(value),
                        child: Text(value.toString()),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(24),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => setState(() {
                    moduleValue = 0; // Reset module value
                    sendPattern();
                  }),
                  child: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    minimumSize: Size(100, 50),
                  ),
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
