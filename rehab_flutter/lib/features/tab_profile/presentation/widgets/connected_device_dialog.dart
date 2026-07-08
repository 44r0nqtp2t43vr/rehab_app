import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/controller/bluetooth_controller.dart';
import 'package:rehab_flutter/injection_container.dart';

class ConnectedDeviceDialog extends StatelessWidget {
  const ConnectedDeviceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final connectedDevice = sl<BluetoothController>().targetDevice;
    final connectedCharacteristic = sl<BluetoothController>().targetCharacteristic;

    return GlassContainer(
      blur: 10,
      color: Colors.white.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Connected Device',
              style: TextStyle(
                fontFamily: 'Sailec Bold',
                fontSize: 22,
                height: 1.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            connectedDevice == null
                ? Text(
                    'You are currently disconnected from the station',
                    style: darkTextTheme().displaySmall,
                  )
                : Row(
                    children: [
                      const Icon(
                        Icons.bluetooth,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              connectedDevice.platformName,
                              style: darkTextTheme().displaySmall,
                            ),
                            Text(
                              connectedCharacteristic == null ? "No characteristic found" : "Characteristic: ${connectedCharacteristic.uuid.toString()}",
                              style: darkTextTheme().headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: Theme(
                data: darkButtonTheme,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
