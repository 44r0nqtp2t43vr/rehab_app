import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:rehab_flutter/config/theme/app_themes.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_bloc.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_event.dart';
import 'package:rehab_flutter/core/bloc/bluetooth/bluetooth_state.dart';
import 'package:rehab_flutter/injection_container.dart';

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BluetoothBloc>()..add(const ScanDevicesEvent()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 120,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: 35,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SizedBox.expand(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF01FF99),
                      Color(0xFF128BED),
                      Color(0xFF16478B),
                    ],
                    stops: [0.0, 0.8, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.3),
              ),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<BluetoothBloc, BluetoothAppState>(
      builder: (context, state) {
        // final List<BluetoothDevice> devices = [
        //   BluetoothDevice(remoteId: const DeviceIdentifier("")),
        //   BluetoothDevice(remoteId: const DeviceIdentifier("")),
        //   BluetoothDevice(remoteId: const DeviceIdentifier("")),
        // ];
        // return SafeArea(
        //   child: Center(
        //     child: Padding(
        //       padding: const EdgeInsets.all(32),
        //       child: GlassContainer(
        //         blur: 4,
        //         color: Colors.white.withOpacity(0.25),
        //         child: Padding(
        //           padding: const EdgeInsets.all(20),
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Text(
        //                 'Bluetooth Devices',
        //                 style: darkTextTheme().headlineMedium,
        //                 textAlign: TextAlign.center,
        //               ),
        //               const SizedBox(
        //                 height: 20,
        //               ),
        //               ListView.builder(
        //                 shrinkWrap: true,
        //                 itemCount: devices.length,
        //                 itemBuilder: (context, index) {
        //                   final BluetoothDevice device = devices[index];
        //                   return Padding(
        //                     padding: const EdgeInsets.all(8),
        //                     child: GlassContainer(
        //                       blur: 4,
        //                       color: Colors.white.withOpacity(0.25),
        //                       child: ListTile(
        //                         leading: const Icon(
        //                           Icons.bluetooth,
        //                           size: 30,
        //                           color: Colors.white,
        //                         ),
        //                         title: Text(
        //                           'Device ${index + 1}',
        //                           style: darkTextTheme().displaySmall,
        //                         ),
        //                         onTap: () {},
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // );

        if (state is BluetoothLoading) {
          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
        } else if (state is BluetoothDone) {
          return StreamBuilder<List<ScanResult>>(
            stream: state.scanResults,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Stream has data
                final scanResults = snapshot.data!.where((scanResult) => scanResult.device.platformName.contains('Gloves')).toList();
                if (scanResults.isNotEmpty) {
                  return SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Text(
                              'Connect to CU.TOUCH Station',
                              style: darkTextTheme().headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'via Bluetooth',
                              style: darkTextTheme().headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: GlassContainer(
                                blur: 4,
                                color: Colors.white.withOpacity(0.25),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Bluetooth Devices',
                                        style: darkTextTheme().headlineMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: scanResults.length,
                                          physics: const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final BluetoothDevice device = scanResults[index].device;
                                            return Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: GlassContainer(
                                                blur: 4,
                                                color: Colors.white.withOpacity(0.25),
                                                child: ListTile(
                                                  leading: const Icon(
                                                    Icons.bluetooth,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  title: Text(
                                                    device.platformName,
                                                    style: darkTextTheme().displaySmall,
                                                  ),
                                                  onTap: () => _onDeviceCardPressed(context, device),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.refresh,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => _onRescan(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        'Connect to CU.TOUCH Station',
                        style: darkTextTheme().headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'via Bluetooth',
                        style: darkTextTheme().headlineSmall,
                      ),
                      const Expanded(
                        child: Center(
                            child: CupertinoActivityIndicator(
                          color: Colors.white,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.refresh,
                                size: 35,
                                color: Colors.white,
                              ),
                              onPressed: () => _onRescan(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }

  void _onDeviceCardPressed(BuildContext context, BluetoothDevice targetDevice) {
    Navigator.pushNamed(context, '/ServiceScreen', arguments: targetDevice);
  }

  void _onRescan() {
    sl<BluetoothBloc>().add(const ScanDevicesEvent());
  }
}
