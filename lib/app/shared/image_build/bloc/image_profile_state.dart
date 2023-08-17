part of 'image_profile_bloc.dart';

abstract class ImageProfileState extends Equatable {
  const ImageProfileState();
}

class InitialImageProfileState extends ImageProfileState {
  const InitialImageProfileState({this.imageBuild});

  final Uint8List? imageBuild;

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
