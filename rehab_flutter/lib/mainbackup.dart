import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothControlPage(),
    );
  }
}

class BluetoothControlPage extends StatefulWidget {
  @override
  _BluetoothControlPageState createState() => _BluetoothControlPageState();
}

class _BluetoothControlPageState extends State<BluetoothControlPage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;

  @override
  @override
  void initState() {
    super.initState();
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      // Iterate over the results to find your device
      for (ScanResult r in results) {
        if (r.device.name == 'Gloves_SPP_01') {
          // Replace with your device's name
          // Stop scanning as soon as we find the device
          flutterBlue.stopScan();

          setState(() {
            connectedDevice = r.device;
          });

          connectToDevice();
          break;
        }
      }
    });
  }

  void connectToDevice() async {
    if (connectedDevice == null) return;

    await connectedDevice!.connect();
    discoverServices();
  }

  void discoverServices() async {
    if (connectedDevice == null) return;

    List<BluetoothService> services = await connectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      print("Service UUID: ${service.uuid}");
      for (BluetoothCharacteristic c in service.characteristics) {
        print("Characteristic UUID: ${c.uuid}");
      }
    }
  }

  void sendData() async {
    final data = "<149149149149149149149149149149>".codeUnits;
    await characteristic?.write(data, withoutResponse: true);
  }

  void disconnect() {
    connectedDevice?.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: sendData,
              child: Text('Send Pattern'),
            ),
            ElevatedButton(
              onPressed: disconnect,
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
