// To parse this JSON data, do
//
//     final profileMap = profileMapFromJson(jsonString);

import 'dart:convert';

ProfileMap profileMapFromJson(String str) => ProfileMap.fromJson(json.decode(str));

String profileMapToJson(ProfileMap data) => json.encode(data.toJson());

class ProfileMap {
  String? status;
  Data? data;
  Properties? properties;

  ProfileMap({
    this.status,
    this.data,
    this.properties,
  });

  ProfileMap copyWith({
    String? status,
    Data? data,
    Properties? properties,
  }) =>
      ProfileMap(
        status: status ?? this.status,
        data: data ?? this.data,
        properties: properties ?? this.properties,
      );

  factory ProfileMap.fromJson(Map<String, dynamic> json) => ProfileMap(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    properties: json["properties"] == null ? null : Properties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "properties": properties?.toJson(),
  };
}

class Data {
  int? idAffiliate;
  String? fullName;
  Birthday? birthday;
  String? email;
  int? idGender;
  String? gender;
  String? phoneNumber;
  String? otherNumber;
  int? idDocumentType;
  String? documentType;
  String? identificationDocument;
  String? speciality;
  String? graduatedFrom;
  String? medicalLicense;
  String? latitude;
  String? longitude;
  String? firekey;
  int? idCity;
  String? city;
  String? state;
  String? country;
  String? direction;

  Data({
    this.idAffiliate,
    this.fullName,
    this.birthday,
    this.email,
    this.idGender,
    this.gender,
    this.phoneNumber,
    this.otherNumber,
    this.idDocumentType,
    this.documentType,
    this.identificationDocument,
    this.speciality,
    this.graduatedFrom,
    this.medicalLicense,
    this.latitude,
    this.longitude,
    this.firekey,
    this.idCity,
    this.city,
    this.state,
    this.country,
    this.direction,
  });

  Data copyWith({
    int? idAffiliate,
    String? fullName,
    Birthday? birthday,
    String? email,
    int? idGender,
    String? gender,
    String? phoneNumber,
    String? otherNumber,
    int? idDocumentType,
    String? documentType,
    String? identificationDocument,
    String? speciality,
    String? graduatedFrom,
    String? medicalLicense,
    String? latitude,
    String? longitude,
    String? firekey,
    int? idCity,
    String? city,
    String? state,
    String? country,
    String? direction,
  }) =>
      Data(
        idAffiliate: idAffiliate ?? this.idAffiliate,
        fullName: fullName ?? this.fullName,
        birthday: birthday ?? this.birthday,
        email: email ?? this.email,
        idGender: idGender ?? this.idGender,
        gender: gender ?? this.gender,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        otherNumber: otherNumber ?? this.otherNumber,
        idDocumentType: idDocumentType ?? this.idDocumentType,
        documentType: documentType ?? this.documentType,
        identificationDocument: identificationDocument ?? this.identificationDocument,
        speciality: speciality ?? this.speciality,
        graduatedFrom: graduatedFrom ?? this.graduatedFrom,
        medicalLicense: medicalLicense ?? this.medicalLicense,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        firekey: firekey ?? this.firekey,
        idCity: idCity ?? this.idCity,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        direction: direction ?? this.direction,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    idAffiliate: json["idAffiliate"],
    fullName: json["fullName"],
    birthday: json["birthday"] == null ? null : Birthday.fromJson(json["birthday"]),
    email: json["email"],
    idGender: json["idGender"],
    gender: json["gender"],
    phoneNumber: json["phoneNumber"],
    otherNumber: json["otherNumber"],
    idDocumentType: json["idDocumentType"],
    documentType: json["documentType"],
    identificationDocument: json["identificationDocument"],
    speciality: json["speciality"],
    graduatedFrom: json["graduatedFrom"],
    medicalLicense: json["medicalLicense"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    firekey: json["firekey"],
    idCity: json["idCity"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    direction: json["direction"],
  );

  Map<String, dynamic> toJson() => {
    "idAffiliate": idAffiliate,
    "fullName": fullName,
    "birthday": birthday?.toJson(),
    "email": email,
    "idGender": idGender,
    "gender": gender,
    "phoneNumber": phoneNumber,
    "otherNumber": otherNumber,
    "idDocumentType": idDocumentType,
    "documentType": documentType,
    "identificationDocument": identificationDocument,
    "speciality": speciality,
    "graduatedFrom": graduatedFrom,
    "medicalLicense": medicalLicense,
    "latitude": latitude,
    "longitude": longitude,
    "firekey": firekey,
    "idCity": idCity,
    "city": city,
    "state": state,
    "country": country,
    "direction": direction,
  };
}

class Birthday {
  int? year;
  int? month;
  int? dayOfMonth;
  int? hourOfDay;
  int? minute;
  int? second;

  Birthday({
    this.year,
    this.month,
    this.dayOfMonth,
    this.hourOfDay,
    this.minute,
    this.second,
  });

  Birthday copyWith({
    int? year,
    int? month,
    int? dayOfMonth,
    int? hourOfDay,
    int? minute,
    int? second,
  }) =>
      Birthday(
        year: year ?? this.year,
        month: month ?? this.month,
        dayOfMonth: dayOfMonth ?? this.dayOfMonth,
        hourOfDay: hourOfDay ?? this.hourOfDay,
        minute: minute ?? this.minute,
        second: second ?? this.second,
      );

  factory Birthday.fromJson(Map<String, dynamic> json) => Birthday(
    year: json["year"],
    month: json["month"],
    dayOfMonth: json["dayOfMonth"],
    hourOfDay: json["hourOfDay"],
    minute: json["minute"],
    second: json["second"],
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "month": month,
    "dayOfMonth": dayOfMonth,
    "hourOfDay": hourOfDay,
    "minute": minute,
    "second": second,
  };
}

class Properties {
  double? timeInSeconds;

  Properties({
    this.timeInSeconds,
  });

  Properties copyWith({
    double? timeInSeconds,
  }) =>
      Properties(
        timeInSeconds: timeInSeconds ?? this.timeInSeconds,
      );

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    timeInSeconds: json["timeInSeconds"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "timeInSeconds": timeInSeconds,
  };
}
