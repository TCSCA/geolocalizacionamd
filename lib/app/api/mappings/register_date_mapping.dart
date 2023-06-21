import 'date_time_mapping.dart';

class RegisterDate {
  DateTime dateTime;

  RegisterDate({
    required this.dateTime,
  });

  factory RegisterDate.fromJson(Map<String, dynamic> json) => RegisterDate(
        dateTime: DateTime.fromJson(json["dateTime"]),
      );
}
