part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetProfileEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class GetProfileInitialEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class EditProfileEvent extends ProfileEvent {
  String? photoProfile, digitalSignature;
  String fullName,
      email,
      dateOfBirth,
      phoneNumber,
      otherPhone,
      direction,
      speciality;
  int idAffiliate, idGender, idCountry, idState, idCity, mpps, cm;

  EditProfileEvent(
      {required this.idAffiliate,
      required this.fullName,
      required this.email,
      required this.dateOfBirth,
      required this.idGender,
      required this.phoneNumber,
      required this.otherPhone,
      required this.idCountry,
      required this.idState,
      required this.idCity,
      required this.direction,
      required this.mpps,
      required this.cm,
      required this.speciality,
      this.photoProfile,
      this.digitalSignature});

  @override
  List<Object?> get props => [
        idAffiliate,
        fullName,
        email,
        dateOfBirth,
        idGender,
        phoneNumber,
        otherPhone,
        idCountry,
        idState,
        idCity,
        direction,
        mpps,
        cm,
        speciality,
        photoProfile,
        digitalSignature
      ];
}
