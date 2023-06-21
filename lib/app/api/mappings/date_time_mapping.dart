import 'date_mapping.dart';
import 'time_mapping.dart';

class DateTime {
  Date date;
  Time time;

  DateTime({
    required this.date,
    required this.time,
  });

  factory DateTime.fromJson(Map<String, dynamic> json) => DateTime(
        date: Date.fromJson(json["date"]),
        time: Time.fromJson(json["time"]),
      );
}
