part of 'image_profile_bloc.dart';

 class ImageProfileState extends Equatable {
  const ImageProfileState({this.imageBuild, this.imagePath});

  final Uint8List? imageBuild;
  final String? imagePath;

  @override
  // TODO: implement props
  List<Object?> get props => [imageBuild, imagePath];
}

