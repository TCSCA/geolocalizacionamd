class ProfileModel {
  int? idAffiliate;
  String? fullName;
  String? dayBirthday;
  String? monthBirthday;
  String? yearBirthday;
  String? email;
  int? idGender;
  String? gender;
  String? phoneNumber;
  String? otherNumber;
  String? identificationDocument;
  String? documentType;
  String? speciality;
  String? graduatedFrom;
  String? medicalLicense;
  int? idCity;
  String? city;
  int? idState;
  String? state;
  String? country;
  String? direction;
  String? mpps;
  String? mc;
  bool? validatePhoto;
  bool? validateSignature;

  ProfileModel({
    this.idAffiliate,
    this.fullName,
    this.dayBirthday,
    this.monthBirthday,
    this.yearBirthday,
    this.idGender,
    this.email,
    this.gender,
    this.phoneNumber,
    this.otherNumber,
    this.identificationDocument,
    this.documentType,
    this.speciality,
    this.graduatedFrom,
    this.medicalLicense,
    this.idCity,
    this.city,
    this.idState,
    this.state,
    this.country,
    this.direction,
    this.mpps,
    this.mc,
    this.validatePhoto,
    this.validateSignature
  });
}
