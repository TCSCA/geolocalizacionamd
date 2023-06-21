class StateMap {
  int stateId;
  String stateName;
  int countryId;

  StateMap(
      {required this.stateId,
      required this.stateName,
      required this.countryId});

  factory StateMap.fromJson(Map<String, dynamic> json) => StateMap(
      stateId: json['idState'] ?? 0,
      stateName: json['state'] ?? '',
      countryId: json['countryEntity']['idCountry'] ?? 0);
}
