class UserMap {
  String status;
  String data;
  int idProfile;
  String descriptionEs;
  int typeProfile;

  UserMap({
    required this.status,
    required this.data,
    required this.idProfile,
    required this.descriptionEs,
    required this.typeProfile,
  });

  factory UserMap.fromJson(Map<String, dynamic> json) => UserMap(
        status: json["status"] ?? '',
        data: json["data"] ?? '',
        idProfile: json["profile"]["idProfile"] ?? 0,
        descriptionEs: json["profile"]["descriptionEs"] ?? '',
        typeProfile: json["profile"]["typeProfile"] ?? 0,
      );
}
