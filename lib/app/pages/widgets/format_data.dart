import '/app/api/mappings/register_date_mapping.dart';

class AppFormatData {
  static DateTime parseFecha(RegisterDate registerDate) {
    String year, month, day, hour, minute, second;
    year = (registerDate.dateTime.date.year).toString();
    month = (registerDate.dateTime.date.month).toString();
    day = (registerDate.dateTime.date.day).toString();
    hour = (registerDate.dateTime.time.hour).toString();
    minute = (registerDate.dateTime.time.minute).toString();
    second = (registerDate.dateTime.time.second).toString();
    return DateTime.parse('$year-$month-$day $hour:$minute:$second');
  }
}
