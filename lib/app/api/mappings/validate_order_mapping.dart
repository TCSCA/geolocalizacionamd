// To parse this JSON data, do
//
//     final validateOrderMap = validateOrderMapFromJson(jsonString);

import 'dart:convert';

ValidateOrderMap validateOrderMapFromJson(String str) => ValidateOrderMap.fromJson(json.decode(str));

String validateOrderMapToJson(ValidateOrderMap data) => json.encode(data.toJson());

class ValidateOrderMap {
  String? status;
  Data? data;
  Properties? properties;

  ValidateOrderMap({
    this.status,
    this.data,
    this.properties,
  });

  ValidateOrderMap copyWith({
    String? status,
    Data? data,
    Properties? properties,
  }) =>
      ValidateOrderMap(
        status: status ?? this.status,
        data: data ?? this.data,
        properties: properties ?? this.properties,
      );

  factory ValidateOrderMap.fromJson(Map<String, dynamic> json) => ValidateOrderMap(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    properties: json["properties"] == null ? null : Properties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "properties": properties?.toJson(),
  };
}

class Data {
  String? code;
  String? message;

  Data({
    this.code,
    this.message,
  });

  Data copyWith({
    String? code,
    String? message,
  }) =>
      Data(
        code: code ?? this.code,
        message: message ?? this.message,
      );

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
  double? timeInSeconds;

  Properties({
    this.timeInSeconds,
  });

  Properties copyWith({
    double? timeInSeconds,
  }) =>
      Properties(
        timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      );

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    timeInSeconds: json["timeInSeconds"],
  );

  Map<String, dynamic> toJson() => {
    "timeInSeconds": timeInSeconds,
  };
}
