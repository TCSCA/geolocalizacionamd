class ProfileModel {
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

  ProfileModel({
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
}

class Birthday {
  int? year;
  int? month;
  int? dayOfMonth;
  int? hourOfDay;
  int? minute;
  int? second;

  Birthday(
      {this.year,
      this.month,
      this.dayOfMonth,
      this.hourOfDay,
      this.minute,
      this.second});
}
