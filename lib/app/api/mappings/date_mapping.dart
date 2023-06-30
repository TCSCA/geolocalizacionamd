class Date {
  int year;
  int month;
  int day;

  Date({
    required this.year,
    required this.month,
    required this.day,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        year: json["year"],
        month: json["month"],
        day: json["day"],
      );
}
