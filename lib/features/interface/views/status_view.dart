import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:status_bluetooth/features/interface/views/bluetooth_off_view.dart';
import 'package:status_bluetooth/features/interface/views/bluetooth_on_view.dart';

class StatusView extends StatelessWidget {
  const StatusView({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
      stream: FlutterBlue.instance.state,
      initialData: BluetoothState.unknown,
      builder: (c, snapshot) {
        final state = snapshot.data;
        if (state == BluetoothState.on) {
          return BluetoothOnView(id: id);
        }
        return const BluetoothOffView();
      },
    );
  }
}
