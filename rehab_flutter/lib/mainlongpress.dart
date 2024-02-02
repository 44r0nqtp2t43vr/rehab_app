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
  Set<int> activeValues = Set(); // Track active button values

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

  void addActiveValue(int valueToAdd) {
    setState(() {
      activeValues.add(valueToAdd); // Add value to active set
      updateModuleValue(); // Update the module value based on active values
    });
  }

  void removeActiveValue(int valueToRemove) {
    setState(() {
      activeValues.remove(valueToRemove); // Remove value from active set
      updateModuleValue(); // Update the module value based on active values
    });
  }

  void updateModuleValue() {
    // Calculate the combined value of all active buttons
    int combinedValue = activeValues.fold(
            0, (previousValue, element) => previousValue + element) %
        256;
    // Send the combined value to the module
    sendPattern(combinedValue);
  }

  void sendPattern(int moduleValue) {
    if (targetCharacteristic == null) return;

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
          child: isDeviceConnected
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRow(1, 8),
                    buildRow(2, 16),
                    buildRow(4, 32),
                    buildRow(64, 128),
                  ],
                )
              : Text('Searching for Device...'),
        ),
      ),
    );
  }

  Widget buildRow(int leftValue, int rightValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButton(leftValue),
        buildButton(rightValue),
      ],
    );
  }

  Widget buildButton(int value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onLongPressStart: (_) => addActiveValue(value),
          onLongPressEnd: (_) => removeActiveValue(value),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(value.toString()),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(24),
            ),
          ),
        ),
      ),
    );
  }
}
