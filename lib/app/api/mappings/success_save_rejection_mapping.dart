// To parse this JSON data, do
//
//     final saveRejectionModel = saveRejectionModelFromJson(jsonString);

import 'dart:convert';

class SaveRejectionModel {
  final String status;
  final Data data;
  final Properties properties;

  SaveRejectionModel({
    required this.status,
    required this.data,
    required this.properties,
  });

  factory SaveRejectionModel.fromRawJson(String str) =>
      SaveRejectionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaveRejectionModel.fromJson(Map<String, dynamic> json) =>
      SaveRejectionModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        properties: Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "properties": properties.toJson(),
      };
}

class Data {
  final String code;
  final String message;

  Data({
    required this.code,
    required this.message,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class Properties {
  final int timeInSeconds;

  Properties({
    required this.timeInSeconds,
  });

  factory Properties.fromRawJson(String str) =>
      Properties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        timeInSeconds: json["timeInSeconds"],
      );

  Map<String, dynamic> toJson() => {
        "timeInSeconds": timeInSeconds,
      };
}
