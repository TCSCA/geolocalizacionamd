part of 'image_profile_bloc.dart';

abstract class ImageProfileEvent extends Equatable {
  const ImageProfileEvent();
}

class SelectImageByGallery extends ImageProfileEvent {

  @override
  List<Object?> get props => [];
}

class SelectImageByCamera extends ImageProfileEvent {
  @override
  List<Object?> get props => [];
}

class CleanImageByProfile extends ImageProfileEvent {
  @override
  List<Object?> get props => [];
}

class ValidatePermissionCameraEvent extends ImageProfileEvent {
  @override
  List<Object?> get props => [];
}

class ValidatePermissionGalleryEvent extends ImageProfileEvent {
  @override
  List<Object?> get props => [];

}

class SelectDoctorSignature extends ImageProfileEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class ConsultPhotoEvent extends ImageProfileEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ConsultDigitalSignatureEvent extends ImageProfileEvent {

  @override
  List<Object?> get props => [];

}
