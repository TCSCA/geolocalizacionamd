// To parse this JSON data, do
//
//     final changePasswordMap = changePasswordMapFromJson(jsonString);

import 'dart:convert';

ChangePasswordMap changePasswordMapFromJson(String str) => ChangePasswordMap.fromJson(json.decode(str));

String changePasswordMapToJson(ChangePasswordMap data) => json.encode(data.toJson());

class ChangePasswordMap {
  String? status;
  Data? data;

  ChangePasswordMap({
    this.status,
    this.data,
  });

  ChangePasswordMap copyWith({
    String? status,
    Data? data,
  }) =>
      ChangePasswordMap(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory ChangePasswordMap.fromJson(Map<String, dynamic> json) => ChangePasswordMap(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
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