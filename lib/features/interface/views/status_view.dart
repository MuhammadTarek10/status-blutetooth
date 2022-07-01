import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:status_bluetooth/features/interface/views/bluetooth_off_view.dart';
import 'package:status_bluetooth/features/interface/views/bluetooth_on_view.dart';

class StatusView extends StatelessWidget {
  StatusView({Key? key}) : super(key: key);

  final InternetConnectionChecker internetConnectionChecker =
      InternetConnectionChecker();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothState.on) {
          // if (internetConnectionChecker.hasConnection) {
          //   return const BluetoothOnView();
          // }
          return const BluetoothOnView();
        }
        return const BluetoothOffView();
      },
    );
  }
}
