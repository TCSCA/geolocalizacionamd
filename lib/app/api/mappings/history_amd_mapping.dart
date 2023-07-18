
import 'home_service_mapping.dart';

class HistoryAmdMap {
  List<HomeServiceMap> data;

  HistoryAmdMap({required this.data});

  factory HistoryAmdMap.fromJson(Map<String, dynamic> json) => HistoryAmdMap(
        data: json['data'] == null
            ? []
            : List<HomeServiceMap>.from(
                json['data'].map((data) => HomeServiceMap.fromJson(data))),
      );
}
