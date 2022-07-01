import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:status_bluetooth/core/utils/app_colors.dart';
import 'package:status_bluetooth/core/utils/app_constants.dart';
import 'package:status_bluetooth/core/utils/app_strings.dart';
import 'package:status_bluetooth/features/data/models/models.dart';
import 'package:http/http.dart' as http;

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
  List<String> macAddressList = [];

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

  void _addToMacAddressList(String macAddress) {
    if (!macAddressList.contains(macAddress)) {
      macAddressList.add(macAddress);
    }
  }

  void _getData() {
    rssiList.clear();
    uuidList.clear();
    log("Started Scanning");
    _flutterBlue.startScan(timeout: const Duration(seconds: 10));
    _flutterBlue.scanResults.listen((results) async {
      for (ScanResult result in results) {
        log("Trying to connect to ${result.device.id.id}");
        _addToMacAddressList(result.device.id.id);
        _addToRSSIList(result.rssi.toString());
        await getUUID(result);
        log(rssiList.toString());
        log(uuidList.toString());
      }
    });
  }

  void _sendToAPI() async {
    http.Client client = http.Client();
    var rssiTosend = 0;
    var uuidToSend = "";
    var macAddressToSend = "";
    final Auth auth = Auth(
      driverManagerId: "1",
      driverManagerPassword: "123",
    );
    if (rssiList.isNotEmpty) {
      rssiTosend = int.parse(rssiList[0]);
    }
    if (uuidList.isNotEmpty) {
      uuidToSend = uuidList[0];
    }
    if (macAddressList.isNotEmpty) {
      macAddressToSend = macAddressList[0];
    }
    final SensorData sensorData = SensorData(
      name: "dummyName",
      macAddress: macAddressToSend,
      uuid: uuidToSend,
      rssi: rssiTosend,
    );
    final SensorInfo sensorInfo = SensorInfo(sensorId: 12950);
    final Package package = Package(
      sensorInfo: sensorInfo,
      sensorData: sensorData,
    );

    final ApiModel apiModel = ApiModel(
      package: package,
      auth: auth,
    );

    log(apiModel.toJson().toString());

    final url = Uri.parse("https://learning.masterofthings.com/PostSensorData");
    final response = await client.post(
      url,
      body: json.encode(apiModel.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      log("GOOD");
    } else {
      log("BAD");
    }
  }

  Future<void> getUUID(ScanResult result) async {
    await result.device.connect(autoConnect: false);
    log("Connected");
    var service = await result.device.discoverServices();
    for (BluetoothService s in service) {
      _addToUUIDList(s.uuid.toString());
      rssiList.sort();
    }
    _sendToAPI();
    log("Disconneting");
    await result.device.disconnect();
    log("Disconnected");
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(
      const Duration(minutes: AppConstants.durationForAPI),
      (timer) => _getData(),
    );
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
