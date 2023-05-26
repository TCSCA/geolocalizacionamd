class UserMap {
  String status;
  List<dynamic> data;
  String token;
  String perfil;
  int idAffiliate;
  int idProfile;

  UserMap({
    required this.status,
    required this.data,
    required this.token,
    required this.perfil,
    required this.idAffiliate,
    required this.idProfile,
  });

  factory UserMap.fromJson(Map<String, dynamic> json) => UserMap(
        status: json["status"] ?? '',
        data: json["data"] ?? [],
        token: json["token"] ?? '',
        perfil: json["perfil"] ?? '',
        idAffiliate: json["idAffiliate"] ?? 0,
        idProfile: json["idProfile"] ?? 0,
      );
}
