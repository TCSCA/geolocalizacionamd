class PhotoMap {
  int idAffiliate;
  int idGender;
  int idDocumentType;
  int idCity;
  List<int> photoProfile;
  List<int> digitalSignature;

  PhotoMap(
      {required this.idAffiliate,
      required this.idGender,
      required this.idDocumentType,
      required this.idCity,
      required this.photoProfile,
      required this.digitalSignature});

  factory PhotoMap.fromJson(Map<String, dynamic> json) => PhotoMap(
        idAffiliate: json["data"]["idAffiliate"] ?? 0,
        idGender: json["data"]["idGender"] ?? 0,
        idDocumentType: json["data"]["idDocumentType"] ?? 0,
        idCity: json["data"]["idCity"] ?? 0,
        photoProfile:
            List<int>.from(json["data"]["photoProfile"].map((x) => x)),
        digitalSignature:
            List<int>.from(json["data"]["digitalSignature"].map((x) => x)),
      );
}
