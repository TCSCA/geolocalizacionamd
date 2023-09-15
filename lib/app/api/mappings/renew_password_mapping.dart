// To parse this JSON data, do
//
//     final renewPasswordMap = renewPasswordMapFromJson(jsonString);

import 'dart:convert';

RenewPasswordMap renewPasswordMapFromJson(String str) => RenewPasswordMap.fromJson(json.decode(str));

String renewPasswordMapToJson(RenewPasswordMap data) => json.encode(data.toJson());

class RenewPasswordMap {
  String? status;
  String? data;

  RenewPasswordMap({
    this.status,
    this.data,
  });

  RenewPasswordMap copyWith({
    String? status,
    String? data,
  }) =>
      RenewPasswordMap(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory RenewPasswordMap.fromJson(Map<String, dynamic> json) => RenewPasswordMap(
    status: json["status"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
  };
}