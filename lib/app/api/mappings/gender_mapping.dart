class GenderMap {
  final String status;
  final String size;
  final List<GenderList> genderList;

  GenderMap({required this.status, required this.size, required this.genderList});

  factory GenderMap.fromJson(Map<String, dynamic> json) => GenderMap(
      status: json['status'] ?? '',
      size: json['size'] ?? '',
      genderList: List<GenderList>.from(json["data"].map((x) => GenderList.fromJson(x))));
}

class GenderList {
  final int idGender;
  final String descriptionEn;
  final String descriptionEs;

  GenderList(
      {required this.idGender,
      required this.descriptionEn,
      required this.descriptionEs});



 factory GenderList.fromJson(Map<String, dynamic> json) => GenderList(
      idGender: json['idGender'] ?? 0,
      descriptionEn: json['descriptionEn'] ?? '',
      descriptionEs: json['descriptionEs'] ?? '');
}
