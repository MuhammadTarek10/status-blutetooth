import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:status_bluetooth/core/utils/app_colors.dart';
import 'package:status_bluetooth/core/utils/app_constants.dart';
import 'package:status_bluetooth/core/utils/app_strings.dart';
import 'package:status_bluetooth/features/data/api/end_points.dart';
import 'package:status_bluetooth/features/data/models/models.dart';
import 'package:http/http.dart' as http;

class BluetoothOnView extends StatefulWidget {
  const BluetoothOnView({Key? key, required this.id}) : super(key: key);

  final String id;

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
  late List<Map<String, dynamic>> _beacons;
  List<Map<String, dynamic>> beconSent = [];
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
    _sensorId = AppConstants.sensorId;
    _driverManagerId = AppConstants.driverManagerId;
    _driverManagerPassword = AppConstants.driverManagerPassword;
    _beacons = [];
    _getData();
  }

  void _addToRSSIList(String rssi) {
    if (!rssiList.contains(rssi)) {
      setState(() {
        rssiList.add(rssi);
      });
    }
  }

  void _addToMacAddressList(String macAddress, int rssi) {
    if (!macAddressList.contains(macAddress)) {
      setState(() {
        macAddressList.add(macAddress);
      });
      _addToRSSIList(rssi.toString());
      _addToBeaconsList({
        json.encode("macAddress"): json.encode(macAddress),
        json.encode("rssi"): json.encode(rssi)
      });
    }
  }

  void _addToBeaconsList(Map<String, dynamic> beacon) {
    _beacons.add(beacon);
  }

  void _getData() async {
    log("Started Scanning");
    _flutterBlue.startScan(timeout: const Duration(seconds: 4));
    _flutterBlue.scanResults.listen(
      (results) async {
        for (ScanResult result in results) {
          log("Trying to connect to ${result.device.id.id}");
          _addToMacAddressList(result.device.id.id, result.rssi);
        }
      },
    );
    log("RSSI List: $rssiList");
    log("Mac Address List: $macAddressList");
    log("Beacon List: $_beacons");
    _sendToAPI();
    rssiList.clear();
    macAddressList.clear();
    _beacons.clear();
  }

  Future<void> _sendToAPI() async {
    if (_beacons.isEmpty) {
      return;
    }

    http.Client client = http.Client();
    final Auth auth = Auth(
      driverManagerId: _driverManagerId,
      driverManagerPassword: _driverManagerPassword,
    );
    final SensorData sensorData = SensorData(
        beacons: "[${_beacons.join(", ")}]",
        lighting: lighting,
        airConditioning: airConditioning,
        participantID: widget.id);
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

    final url = Uri.parse(EndPoints.sensorDataAPI);
    final response = await client.post(
      url,
      body: json.encode(apiModel.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      AppConstants.showToast(message: "Sending to API");
      log("GOOD");
    } else {
      log("BAD");
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(
      Duration(seconds: period),
      (timer) => _getData(),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: TextFormField(
              controller: sensorIdController,
              decoration: const InputDecoration(
                hintText: AppStrings.enterSensorId,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: TextFormField(
              controller: driverManagerController,
              decoration: const InputDecoration(
                hintText: AppStrings.enterDriverManagerId,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: TextFormField(
              controller: driverPasswordController,
              decoration: const InputDecoration(
                hintText: AppStrings.enterDriverManagerPassword,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: TextFormField(
              controller: periodTextEditingController,
              decoration: const InputDecoration(
                hintText: AppStrings.period,
              ),
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
                      : AppConstants.sensorId;
                  _driverManagerId = driverManagerController.text.isNotEmpty
                      ? driverManagerController.text
                      : AppConstants.driverManagerId;
                  _driverManagerPassword =
                      driverPasswordController.text.isNotEmpty
                          ? driverPasswordController.text
                          : AppConstants.driverManagerPassword;
                  period = periodTextEditingController.text.isNotEmpty
                      ? int.parse(periodTextEditingController.text)
                      : AppConstants.durationForAPI;
                  _getData();
                },
              )),
        ]),
      ),
    );
  }
}
