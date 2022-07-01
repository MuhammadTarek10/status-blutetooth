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
        required this.name,
        required this.macAddress,
        required this.uuid,
        required this.rssi,
    });

    String name;
    String macAddress;
    String uuid;
    int rssi;

    factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
        name: json["name"],
        macAddress: json["macAddress"],
        uuid: json["uuid"],
        rssi: json["rssi"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "macAddress": macAddress,
        "uuid": uuid,
        "rssi": rssi,
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
