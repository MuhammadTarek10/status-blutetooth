import 'package:flutter/material.dart';
import 'package:status_bluetooth/core/utils/app_strings.dart';

class BluetoothOffView extends StatefulWidget {
  const BluetoothOffView({Key? key}) : super(key: key);

  @override
  State<BluetoothOffView> createState() => _BluetoothOffViewState();
}

class _BluetoothOffViewState extends State<BluetoothOffView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bluetoothOffView),
      ),
    );
  }
}
