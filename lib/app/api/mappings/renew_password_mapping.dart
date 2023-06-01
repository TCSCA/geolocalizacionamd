// To parse this JSON data, do
//
//     final renewPasswordMap = renewPasswordMapFromJson(jsonString);

import 'dart:convert';

RenewPasswordMap renewPasswordMapFromJson(String str) => RenewPasswordMap.fromJson(json.decode(str));

String renewPasswordMapToJson(RenewPasswordMap data) => json.encode(data.toJson());

class RenewPasswordMap {
  String status;
  String msg;
  List<dynamic> data;

  RenewPasswordMap({
    required this.status,
    required this.msg,
    required this.data,
  });

  RenewPasswordMap copyWith({
    String? status,
    String? msg,
    List<dynamic>? data,
  }) =>
      RenewPasswordMap(
        status: status ?? this.status,
        msg: msg ?? this.msg,
        data: data ?? this.data,
      );

  factory RenewPasswordMap.fromJson(Map<String, dynamic> json) => RenewPasswordMap(
    status: json["status"],
    msg: json["msg"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
