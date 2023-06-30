class CityMap {
  int cityId;
  String cityName;
  int stateId;

  CityMap(
      {required this.cityId, required this.cityName, required this.stateId});

  factory CityMap.fromJson(Map<String, dynamic> json) => CityMap(
      cityId: json['idCity'] ?? 0,
      cityName: json['description'] ?? '',
      stateId: json['stateEntity']['idState'] ?? 0);
}
