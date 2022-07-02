// To parse this JSON data, do
//
//     final apiModel = apiModelFromJson(jsonString);

import 'dart:convert';

ApiModel apiModelFromJson(String str) => ApiModel.fromJson(json.decode(str));

String apiModelToJson(ApiModel data) => json.encode(data.toJson());

class ApiModel {
  ApiModel({
    required this.package,
    required this.auth,
  });

  Package package;
  Auth auth;

  factory ApiModel.fromJson(Map<String, dynamic> json) => ApiModel(
        package: Package.fromJson(json["Package"]),
        auth: Auth.fromJson(json["Auth"]),
      );

  Map<String, dynamic> toJson() => {
        "Package": package.toJson(),
        "Auth": auth.toJson(),
      };
}

class Auth {
  Auth({
    required this.driverManagerId,
    required this.driverManagerPassword,
  });

  String driverManagerId;
  String driverManagerPassword;

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        driverManagerId: json["DriverManagerId"],
        driverManagerPassword: json["DriverManagerPassword"],
      );

  Map<String, dynamic> toJson() => {
        "DriverManagerId": driverManagerId,
        "DriverManagerPassword": driverManagerPassword,
      };
}

class Package {
  Package({
    required this.sensorInfo,
    required this.sensorData,
  });

  SensorInfo sensorInfo;
  SensorData sensorData;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        sensorInfo: SensorInfo.fromJson(json["SensorInfo"]),
        sensorData: SensorData.fromJson(json["SensorData"]),
      );

  Map<String, dynamic> toJson() => {
        "SensorInfo": sensorInfo.toJson(),
        "SensorData": sensorData.toJson(),
      };
}

class SensorData {
  SensorData({
    required this.beacons,
    required this.lighting,
    required this.airConditioning,
  });

  String beacons;
  bool lighting;
  bool airConditioning;

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        beacons: json["beacons"],
        lighting: json["lighting"],
        airConditioning: json["airConditioning"],
      );

  Map<String, dynamic> toJson() => {
        "beacons": beacons,
        "lighting": lighting,
        "airConditioning": airConditioning,
      };
}

class SensorInfo {
  SensorInfo({
    required this.sensorId,
  });

  int sensorId;

  factory SensorInfo.fromJson(Map<String, dynamic> json) => SensorInfo(
        sensorId: json["SensorId"],
      );

  Map<String, dynamic> toJson() => {
        "SensorId": sensorId,
      };
}

class BeaconModel {
  String macAddress;
  int rssi;

  BeaconModel({
    required this.macAddress,
    required this.rssi,
  });

  @override
  bool operator ==(Object other) {
    return (other is BeaconModel) &&
        other.macAddress == macAddress &&
        other.rssi == rssi;
  }

  @override
  int get hashCode => macAddress.hashCode ^ rssi.hashCode;
}

class BeaconList {
  static List<BeaconModel>? beaconList;

  void addBeacon(BeaconModel beacon) {
    for (BeaconModel b in beaconList!) {
      if (b.macAddress != beacon.macAddress) {
        beaconList!.add(beacon);
        return;
      }
    }
  }

  void clearList() {
    beaconList!.clear();
  }

  @override
  String toString() {
    return "$beaconList";
  }

  @override
  bool operator ==(Object other) {
    return (other is BeaconList) && BeaconList.beaconList == beaconList;
  }

  @override
  int get hashCode => beaconList.hashCode;
}
