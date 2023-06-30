class Time {
  int hour;
  int minute;
  int second;
  int nano;

  Time({
    required this.hour,
    required this.minute,
    required this.second,
    required this.nano,
  });

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        hour: json["hour"],
        minute: json["minute"],
        second: json["second"],
        nano: json["nano"],
      );
}
