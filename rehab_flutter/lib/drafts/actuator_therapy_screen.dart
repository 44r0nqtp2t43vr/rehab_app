import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/injection_container.dart';
import 'package:rehab_flutter/providers.dart';

class ActuatorTherapy extends StatefulWidget {
  final BluetoothCharacteristic targetCharacteristic;

  ActuatorTherapy({Key? key, required this.targetCharacteristic})
      : super(key: key);

  @override
  _ActuatorTherapyState createState() => _ActuatorTherapyState();
}

class _ActuatorTherapyState extends State<ActuatorTherapy> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? targetDevice;
  final String targetDeviceName = "Gloves_BLE_01";
  bool isDeviceConnected = false;
  Set<int> activeValues = Set<int>(); // Ensure type specification for clarity

  @override
  void initState() {
    super.initState();
  }

  void addActiveValue(int valueToAdd) {
    setState(() {
      activeValues.add(valueToAdd);
      updateModuleValue();
    });
  }

  void removeActiveValue(int valueToRemove) {
    setState(() {
      activeValues.remove(valueToRemove);
      updateModuleValue();
    });
  }

  void updateModuleValue() {
    int combinedValue = activeValues.fold(
            0, (previousValue, element) => previousValue + element) %
        256;
    sendPattern(combinedValue);
  }

  void sendPattern(int moduleValue) {
    if (widget.targetCharacteristic == null) return;

    String moduleValueString = moduleValue.toString().padLeft(3, '0');
    String data = "<" + List.filled(10, moduleValueString).join() + ">";

    // widget.targetCharacteristic!.write(data.codeUnits, withoutResponse: true);
    sl<BluetoothBloc>().add(WriteDataEvent(data));
    print("Pattern sent: $data");
  }

  void toggleActiveValue(int value) {
    setState(() {
      if (activeValues.contains(value)) {
        activeValues.remove(value);
      } else {
        activeValues.add(value);
      }
      updateModuleValue();
    });
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
          children: [
            buildRow(1, 8),
            buildRow(2, 16),
            buildRow(4, 32),
            buildRow(64, 128),
            Text("Characteristic Selected: ${widget.targetCharacteristic.uuid}")
          ],
        )),
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
          onDoubleTap: () => toggleActiveValue(value),
          onLongPressStart: (_) => addActiveValue(value),
          onLongPressEnd: (_) => removeActiveValue(value),
          child: ElevatedButton(
            onPressed:
                () {}, // Empty function, we are using GestureDetector instead
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
