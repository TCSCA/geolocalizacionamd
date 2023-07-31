class GenderMap {
  final String status;
  final String size;
  final List<Data> data;

  GenderMap({required this.status, required this.size, required this.data});

  factory GenderMap.fromJson(Map<String, dynamic> json) => GenderMap(
      status: json['status'] ?? '',
      size: json['size'] ?? '',
      data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))));
}

class Data {
  final int idGender;
  final String descriptionEn;
  final String descriptionEs;

  Data(
      {required this.idGender,
      required this.descriptionEn,
      required this.descriptionEs});



 factory Data.fromJson(Map<String, dynamic> json) => Data(
      idGender: json['idGender'] ?? 0,
      descriptionEn: json['descriptionEn'] ?? '',
      descriptionEs: json['descriptionEs'] ?? '');
}
