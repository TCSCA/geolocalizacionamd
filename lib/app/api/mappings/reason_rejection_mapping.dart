// To parse this JSON data, do
//
//     final reasonRejectionMapping = reasonRejectionMappingFromJson(jsonString);

import 'dart:convert';

class ReasonRejectionMapping {
  final String status;
  List<Datum> data;
  final Properties properties;

  ReasonRejectionMapping({
    required this.status,
    required this.data,
    required this.properties,
  });

  factory ReasonRejectionMapping.fromRawJson(String str) =>
      ReasonRejectionMapping.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReasonRejectionMapping.fromJson(Map<String, dynamic> json) =>
      ReasonRejectionMapping(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        properties: Properties.fromJson(json["properties"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "properties": properties.toJson(),
      };
}

class Datum {
  final int idReasonRejection;
  final String reasonForRejection;
  final int typeReasonRejection;

  Datum({
    required this.idReasonRejection,
    required this.reasonForRejection,
    required this.typeReasonRejection,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idReasonRejection: json["idReasonRejection"] ?? 0,
        reasonForRejection: json["reasonForRejection"] ?? '',
        typeReasonRejection: json["typeReasonRejection"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "idReasonRejection": idReasonRejection,
        "reasonForRejection": reasonForRejection,
        "typeReasonRejection": typeReasonRejection,
      };
}

class Properties {
  final double timeInSeconds;

  Properties({
    required this.timeInSeconds,
  });

  factory Properties.fromRawJson(String str) =>
      Properties.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        timeInSeconds: json["timeInSeconds"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "timeInSeconds": timeInSeconds,
      };
}
