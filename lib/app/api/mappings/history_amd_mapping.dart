import 'dart:convert';

import 'home_service_mapping.dart';

class HistoryAmdMap {
  HomeServiceMap? data;

  HistoryAmdMap({required this.data});

  factory HistoryAmdMap.fromJson(Map<String, dynamic> json) => HistoryAmdMap(
  data: json['data'] == null ? null : HomeServiceMap.fromJson(json["data"]));
}
