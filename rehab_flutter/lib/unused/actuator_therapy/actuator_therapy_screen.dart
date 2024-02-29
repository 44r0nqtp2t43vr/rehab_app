import 'package:flutter/material.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/unused/actuator_therapy/actuator_buttons.dart';
import 'package:rehab_flutter/injection_container.dart';

class ActuatorTherapy extends StatefulWidget {
  const ActuatorTherapy({Key? key}) : super(key: key);

  @override
  State<ActuatorTherapy> createState() => _ActuatorTherapyState();
}

class _ActuatorTherapyState extends State<ActuatorTherapy> with SingleTickerProviderStateMixin {
  Set<int> activeValues = <int>{}; // Ensure type specification for clarity

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
    int combinedValue = activeValues.fold(0, (previousValue, element) => previousValue + element) % 256;
    sendPattern(combinedValue);
  }

  void sendPattern(int moduleValue) {
    String moduleValueString = moduleValue.toString().padLeft(3, '0');
    String data = "<${List.filled(10, moduleValueString).join()}>";

    sl<BluetoothBloc>().add(WriteDataEvent(data));
    debugPrint("Pattern sent: $data");
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

  Widget buildButtonRow(List<int> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: values
          .map((value) => buildButton(
                value: value,
                onDoubleTap: () => toggleActiveValue(value),
                onLongPressStart: () => addActiveValue(value),
                onLongPressEnd: () => removeActiveValue(value),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Device Connector'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Adjusting the rows according to the new layout specifications
            buildButtonRow([1, 8]),
            buildButtonRow([2, 16]),
            buildButtonRow([4, 32]),
            buildButtonRow([64, 128]),
            Text("Characteristic Selected: ${sl<BluetoothController>().targetCharacteristic.uuid}"),
          ],
        )),
      ),
    );
  }
}
