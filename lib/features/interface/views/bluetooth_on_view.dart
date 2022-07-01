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
  late int period;
  late int _sensorId;
  late String _driverManagerId;
  late String _driverManagerPassword;
  late String _name;
  String uuidSent = "";
  int rssiSent = 0;
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  final TextEditingController sensorIdController = TextEditingController();
  final TextEditingController driverManagerController = TextEditingController();
  final TextEditingController driverPasswordController =
      TextEditingController();
  final TextEditingController periodTextEditingController =
      TextEditingController();
  List<String> uuidList = [];
  List<String> rssiList = [];
  List<String> macAddressList = [];

  @override
  void dispose() {
    sensorIdController.dispose();
    driverManagerController.dispose();
    driverPasswordController.dispose();
    periodTextEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    period = AppConstants.durationForAPI;
    _sensorId = 12950;
    _driverManagerId = "1";
    _driverManagerPassword = "123";
    _name = "";
    _getData();
  }

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

  void _getData() async {
    rssiList.clear();
    uuidList.clear();
    macAddressList.clear();
    log("Started Scanning");
    _flutterBlue.startScan(timeout: const Duration(seconds: 4));
    _flutterBlue.scanResults.listen((results) async {
      for (ScanResult result in results) {
        log("Trying to connect to ${result.device.id.id}");
        _addToMacAddressList(result.device.id.id);
        _addToRSSIList(result.rssi.toString());
        await getUUID(result);
      }
    });
  }

  Future<void> getUUID(ScanResult result) async {
    await result.device.connect(autoConnect: false);
    log("Connected");
    var service = await result.device.discoverServices();
    for (BluetoothService s in service) {
      _addToUUIDList(s.uuid.toString());
      await _sendToAPI();
      rssiList.sort();
    }
    log("Disconneting");
    await result.device.disconnect();
    log("Disconnected");
  }

  Future<void> _sendToAPI() async {
    http.Client client = http.Client();
    var rssiTosend = 0;
    var uuidToSend = "";
    var macAddressToSend = "";
    final Auth auth = Auth(
      driverManagerId: _driverManagerId,
      driverManagerPassword: _driverManagerPassword,
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
    if (uuidSent == uuidToSend && rssiSent == rssiTosend) {
      return;
    }
    AppConstants.showToast(message: "Sending to API");
    final SensorData sensorData = SensorData(
      name: _name,
      macAddress: macAddressToSend,
      uuid: uuidToSend,
      rssi: rssiTosend,
    );
    final SensorInfo sensorInfo = SensorInfo(sensorId: _sensorId);
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
    uuidSent = uuidToSend;
    rssiSent = rssiTosend;
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

  @override
  Widget build(BuildContext context) {
    Timer.periodic(
      Duration(minutes: period),
      (timer) => _getData(),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
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
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          const Text(AppStrings.advancedSettings),
          TextFormField(
            controller: sensorIdController,
            decoration: const InputDecoration(
              hintText: AppStrings.enterSensorId,
            ),
          ),
          TextFormField(
            controller: driverManagerController,
            decoration: const InputDecoration(
              hintText: AppStrings.enterDriverManagerId,
            ),
          ),
          TextFormField(
            controller: driverPasswordController,
            decoration: const InputDecoration(
              hintText: AppStrings.enterDriverManagerPassword,
            ),
          ),
          TextFormField(
            controller: periodTextEditingController,
            decoration: const InputDecoration(
              hintText: AppStrings.period,
            ),
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
                  _sensorId = sensorIdController.text.isNotEmpty
                      ? int.parse(sensorIdController.text)
                      : 12950;
                  _driverManagerId = driverManagerController.text.isNotEmpty
                      ? driverManagerController.text
                      : "1";
                  _driverManagerPassword =
                      driverPasswordController.text.isNotEmpty
                          ? driverPasswordController.text
                          : "123";
                  period = periodTextEditingController.text.isNotEmpty
                      ? int.parse(periodTextEditingController.text)
                      : 5;
                  _getData();
                },
              )),
        ]),
      ),
    );
  }
}
