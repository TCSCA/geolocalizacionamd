part of 'image_profile_bloc.dart';

abstract class ImageProfileEvent extends Equatable {
  const ImageProfileEvent();
}

class ImageProfileInitialEvent extends ImageProfileEvent {
  final Uint8List? imageBuild;

  const ImageProfileInitialEvent({this.imageBuild});

  @override
  List<Object?> get props => [imageBuild];
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
  List<Object?> get props => [];
}

class ConsultPhotoEvent extends ImageProfileEvent {
  const ConsultPhotoEvent();

  @override
  List<Object?> get props => [];
}

class ConsultDigitalSignatureEvent extends ImageProfileEvent {
  @override
  List<Object?> get props => [];
}

// Event to switch between front and back cameras
class CameraSwitch extends ImageProfileEvent {
  @override
  List<Object?> get props => [];
}

// Event to disable the camera when not in use
class CameraDisable extends ImageProfileEvent {
  @override
  List<Object?> get props => [];
}

// Event to enable the camera when in use
class CameraEnable extends ImageProfileEvent {
  @override
  List<Object?> get props => [];
}

// Event to reset the camera BLoC to its initial state
class CameraReset extends ImageProfileEvent {
  @override
  List<Object?> get props => [];
}

class CameraTakePicture extends ImageProfileEvent {
  @override
  List<Object?> get props => [];
}
