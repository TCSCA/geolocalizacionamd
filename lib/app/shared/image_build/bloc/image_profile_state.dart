part of 'image_profile_bloc.dart';

abstract class ImageProfileState extends Equatable {
  const ImageProfileState();
}

class ImageProfileInitial extends ImageProfileState {
  @override
  List<Object> get props => [];
}

class ImageChangeSuccessState extends ImageProfileState {

 const ImageChangeSuccessState({this.imageBuild, this.imagePath});

   final Uint8List? imageBuild;
   final String? imagePath;

  @override
  List<Object?> get props => [imageBuild, imagePath];

}

class ValidatePermissionImageState  extends ImageProfileState{
  @override
  List<Object?> get props => [];

}

class ImageErrorState extends ImageProfileState {
  @override

  List<Object?> get props => [];

}
