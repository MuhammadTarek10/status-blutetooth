import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothOnController extends BluetoothOnControllerInput
    with BluetoothOnControllerOutout {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  List<String> uuidList = [];
  List<String> rssiList = [];

  final StreamController _lightingStreamController =
      StreamController<bool>.broadcast();
  final StreamController _airConditioningStreamController =
      StreamController<bool>.broadcast();

  void start() {
    // _flutterBlue.startScan();
  }

  void disponse() {
    _flutterBlue.stopScan();
    _lightingStreamController.close();
    _airConditioningStreamController.close();
  }

  @override
  Stream<bool> get outAirconditioning => _airConditioningStreamController.stream
      .map((airConditioning) => airConditioning);

  @override
  Stream<bool> get outLighting =>
      _lightingStreamController.stream.map((lighting) => lighting);

  @override
  Sink get airConditioning => _airConditioningStreamController.sink;

  @override
  Sink get lighting => _lightingStreamController.sink;

  _addToRSSIList(String rssi) {
    if (!rssiList.contains(rssi)) {
      rssiList.add(rssi);
    }
  }

  _addToUUIDList(String uuid) {
    if (!uuidList.contains(uuid)) {
      uuidList.add(uuid);
    }
  }

  @override
  Future<void> getData() async {
    uuidList.clear();
    rssiList.clear();
    _flutterBlue.startScan(timeout: const Duration(seconds: 4));
    _flutterBlue.scanResults.listen((results) async {
      for (ScanResult result in results) {
        _addToRSSIList(result.rssi.toString());
        await result.device.connect(autoConnect: false);
        List<BluetoothService> services =
            await result.device.discoverServices();
        for (BluetoothService service in services) {
          _addToUUIDList(service.uuid.toString());
        }
        log(rssiList.toString());
        log(uuidList.toString());
        await result.device.disconnect();
      }
    });
  }

  @override
  sendToAPI() {
    throw UnimplementedError();
  }

  @override
  Stream<bool> get outScanning => _flutterBlue.isScanning;
}

abstract class BluetoothOnControllerInput {
  Sink get lighting;
  Sink get airConditioning;

  sendToAPI();
  getData();
}

abstract class BluetoothOnControllerOutout {
  Stream<bool> get outLighting;
  Stream<bool> get outAirconditioning;
  Stream<bool> get outScanning;
}
