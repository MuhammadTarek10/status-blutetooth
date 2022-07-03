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
    required this.participantID,
  });

  String beacons;
  bool lighting;
  bool airConditioning;
  String participantID;

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        beacons: json["beacons"],
        lighting: json["lighting"],
        airConditioning: json["airConditioning"],
        participantID: json["participantID"],
      );

  Map<String, dynamic> toJson() => {
        "beacons": beacons,
        "lighting": lighting,
        "airConditioning": airConditioning,
        "participantID": participantID,
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

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        required this.appId,
        required this.limit,
        required this.conditionList,
        required this.auth,
    });

    int appId;
    int limit;
    List<ConditionList> conditionList;
    AuthLogin auth;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        appId: json["AppId"],
        limit: json["Limit"],
        conditionList: List<ConditionList>.from(json["ConditionList"].map((x) => ConditionList.fromJson(x))),
        auth: AuthLogin.fromJson(json["Auth"]),
    );

    Map<String, dynamic> toJson() => {
        "AppId": appId,
        "Limit": limit,
        "ConditionList": List<dynamic>.from(conditionList.map((x) => x.toJson())),
        "Auth": auth.toJson(),
    };
}

class ConditionList {
    ConditionList({
        required this.reading,
        required this.condition,
        required this.value,
    });

    String reading;
    String condition;
    String value;

    factory ConditionList.fromJson(Map<String, dynamic> json) => ConditionList(
        reading: json["Reading"],
        condition: json["Condition"],
        value: json["Value"],
    );

    Map<String, dynamic> toJson() => {
        "Reading": reading,
        "Condition": condition,
        "Value": value,
    };
}

class AuthLogin {
    AuthLogin({
        required this.key,
    });

    String key;

    factory AuthLogin.fromJson(Map<String, dynamic> json) => AuthLogin(
        key: json["Key"],
    );

    Map<String, dynamic> toJson() => {
        "Key": key,
    };
}
