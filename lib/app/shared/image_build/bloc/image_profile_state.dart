part of 'image_profile_bloc.dart';

abstract class ImageProfileState extends Equatable {
  const ImageProfileState();
}

class InitialImageProfileState extends ImageProfileState {
  const InitialImageProfileState({this.imageBuild, this.imagePath});
  final Uint8List? imageBuild;
  final String? imagePath;
  @override
  List<Object?> get props => [imageBuild];
}

class LoadingImageState extends ImageProfileState {
  @override
  List<Object> get props => [];
}

class ImageChangeSuccessState extends ImageProfileState {
  const ImageChangeSuccessState(
      {this.imageBuild,
      this.imagePath,
      this.doctorSignaturePath,
      this.doctorSignatureBuild});

  final Uint8List? imageBuild;
  final String? imagePath;
  final Uint8List? doctorSignatureBuild;
  final String? doctorSignaturePath;

  @override
  List<Object?> get props =>
      [imageBuild, imagePath, doctorSignatureBuild, doctorSignaturePath];
}

class ValidatePermissionImageState extends ImageProfileState {
  @override
  List<Object?> get props => [];
}

class ImageErrorState extends ImageProfileState {
  final String messageError;

  const ImageErrorState({required this.messageError});

  @override
  List<Object?> get props => [messageError];
}

class CameraPermissionSuccessState extends ImageProfileState {
  final String typePermission;

  const CameraPermissionSuccessState({required this.typePermission});

  @override
  List<Object?> get props => [typePermission];
}

// Camera initial state when it's not yet initialized
class CameraInitial extends ImageProfileState {
  final CameraController cameraController;

  const CameraInitial({required this.cameraController});
  @override
  List<Object?> get props => [cameraController];
}

class CameraReady extends ImageProfileState {
  final CameraController cameraController;

  const CameraReady({required this.cameraController});

  @override
  List<Object?> get props => [cameraController];
}

class CameraChangeSucces extends ImageProfileState {
  final Uint8List? image;
  final String? path;

  const CameraChangeSucces({required this.image, required this.path});
  @override
  List<Object?> get props => [image, path];
}

class TakePicktureSuccess extends ImageProfileState {
  final Uint8List? image;

  const TakePicktureSuccess({required this.image});
  @override
  List<Object?> get props => [image];
}

// Camera error state when an error occurs during camera operations
class CameraError extends ImageProfileState {
  final CameraErrorType error; // The type of camera error that occurred
  const CameraError({
    required this.error,
  });
  @override
  List<Object> get props => [error];
}
