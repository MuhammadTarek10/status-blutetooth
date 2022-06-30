import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:status_bluetooth/core/utils/app_colors.dart';
import 'package:status_bluetooth/core/utils/app_strings.dart';

class BluetoothOnView extends StatefulWidget {
  const BluetoothOnView({Key? key}) : super(key: key);

  @override
  State<BluetoothOnView> createState() => _BluetoothOnViewState();
}

class _BluetoothOnViewState extends State<BluetoothOnView> {
  bool lighting = false;
  bool airConditioning = false;
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  List<String> uuidList = [];
  List<String> rssiList = [];

  void _addToUUIDList(String uuid) {
    if (!uuidList.contains(uuid)) {
      uuidList.add(uuid);
    }
  }

  void _addToRSSIList(String rssi) {
    if (!rssiList.contains(rssi)) {
      rssiList.add(rssi);
    }
  }

  void _getData() {
    rssiList.clear();
    uuidList.clear();
    _flutterBlue.startScan(timeout: const Duration(seconds: 10));
    _flutterBlue.scanResults.listen((results) async {
      for (ScanResult result in results) {
        log("Trying to connect to ${result.device.id.id}");
        _addToRSSIList(result.rssi.toString());
        await getUUID(result);
        log(rssiList.toString());
        log(uuidList.toString());
      }
    });
  }

  Future<void> getUUID(ScanResult result) async {
    await result.device.connect(autoConnect: false);
    log("Connected");
    var service = await result.device.discoverServices();
    for (BluetoothService s in service) {
      _addToUUIDList(s.uuid.toString());
    }
    log("Disconneting");
    await result.device.disconnect();
    log("Disconnected");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text(AppStrings.lightingCheckBox),
                  activeColor: AppColors.checkBoxActiveColor,
                  value: lighting,
                  onChanged: (value) {
                    setState(() {
                      lighting = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text(AppStrings.airConditioningCheckBox),
                  activeColor: AppColors.checkBoxActiveColor,
                  value: airConditioning,
                  onChanged: (value) {
                    setState(() {
                      airConditioning = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.1,
            child: ElevatedButton(
              child: const Text(AppStrings.configure),
              onPressed: () {
                log(lighting.toString());
                log(airConditioning.toString());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () {
                _flutterBlue.stopScan();
              },
              backgroundColor: AppColors.stopColor,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              onPressed: () => _getData(),
              child: const Icon(Icons.search),
            );
          }
        },
      ),
    );
  }
}
