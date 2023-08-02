
import 'dart:convert';

ProfileMap profileMapFromJson(String str) => ProfileMap.fromJson(json.decode(str));

class ProfileMap {
  String? status;
  Data? data;
  Properties? properties;

  ProfileMap({
    this.status,
    this.data,
    this.properties,
  });

  factory ProfileMap.fromJson(Map<String, dynamic> json) => ProfileMap(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    properties: json["properties"] == null ? null : Properties.fromJson(json["properties"]),
  );

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
  int? idstate;
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
    this.idstate,
    this.state,
    this.country,
    this.direction,
  });

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
    idstate: json["idState"],
    state: json["state"],
    country: json["country"],
    direction: json["direction"],
  );

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


  factory Birthday.fromJson(Map<String, dynamic> json) => Birthday(
    year: json["year"],
    month: json["month"],
    dayOfMonth: json["dayOfMonth"],
    hourOfDay: json["hourOfDay"],
    minute: json["minute"],
    second: json["second"],
  );
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

}
