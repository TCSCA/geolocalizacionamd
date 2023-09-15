class FileAmdFormMap {
  String status;
  Data? data;

  FileAmdFormMap({
    required this.status,
    required this.data
});

  factory FileAmdFormMap.fromJson(Map<String, dynamic> json) => FileAmdFormMap(
    status: json["status"] ?? '',
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  int idResultMedicalServices;
  String fileName;
  List<int> file;
/*  IssueDate issueDate;
  UploadDate uploadDate;*/
  bool status;
  String filePath;

  Data({
   required this.idResultMedicalServices,
   required this.fileName,
   required this.file,
/*   required this.issueDate,
   required this.uploadDate,*/
   required this.status,
   required this.filePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    idResultMedicalServices: json["idResultMedicalServices"],
    fileName: json["fileName"],
    file: json["file"] == null ? [] : List<int>.from(json["file"]!.map((x) => x)),
/*    issueDate: json["issueDate"] == null ? null : IssueDate.fromJson(json["issueDate"]),
    uploadDate: json["uploadDate"] == null ? null : UploadDate.fromJson(json["uploadDate"]),*/
    status: json["status"],
    filePath: json["filePath"],
  );
}

/*
class IssueDate {
  int year;
  int month;
  int dayOfMonth;
  int hourOfDay;
  int minute;
  int second;

  IssueDate({
   required this.year,
   required this.month,
   required this.dayOfMonth,
   required this.hourOfDay,
   required this.minute,
   required this.second,
  });

  factory IssueDate.fromJson(Map<String, dynamic> json) =>
      IssueDate(
        year: json["year"] ?? 0,
        month: json["month"] ?? 0,
        dayOfMonth: json["dayOfMonth"] ?? 0,
        hourOfDay: json["hourOfDay"] ?? 0,
        minute: json["minute"] ?? 0,
        second: json["second"] ?? 0,
      );
}

class UploadDate {
  DateTime? dateTime;
  Offset? offset;

  UploadDate({
    this.dateTime,
    this.offset,
  });

  factory UploadDate.fromJson(Map<String, dynamic> json) =>
      UploadDate(
        dateTime: json["dateTime"] == null ? null : DateTime.fromJson(
            json["dateTime"]),
        offset: json["offset"] == null ? null : Offset.fromJson(json["offset"]),
      );
}*/
