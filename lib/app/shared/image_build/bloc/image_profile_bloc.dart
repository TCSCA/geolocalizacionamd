import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/controllers/image_profile_controller.dart';

part 'image_profile_event.dart';

part 'image_profile_state.dart';

class ImageProfileBloc extends Bloc<ImageProfileEvent, ImageProfileState> {
  ImageProfileBloc() : super(const InitialImageProfileState()) {

    Uint8List? bytesImage;
    String? imagePath;

    Uint8List? doctorSignatureBuild;
    String doctorSignaturePath;

    on<ImageProfileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ImageProfileInitialEvent>((event, emit) {
      emit(InitialImageProfileState(imageBuild: event.imageBuild));
    });

    on<SelectImageByCamera>((event, emit) async {
      bytesImage = await ImageProfileController().selectImageByCameraCtrl();

      imagePath = const Base64Encoder().convert(List.from(bytesImage!));

      emit(ImageChangeSuccessState(
          imageBuild: bytesImage, imagePath: imagePath));
    });

    on<SelectImageByGallery>((event, emit) async {
      bytesImage = await ImageProfileController().selectImageByGalleryCtrl();
      imagePath = const Base64Encoder().convert(List.from(bytesImage!));

      emit(ImageChangeSuccessState(
          imageBuild: bytesImage, imagePath: imagePath));
    });

    on<CleanImageByProfile>((event, emit) async {
      emit(const ImageChangeSuccessState(imageBuild: null, imagePath: null));
    });

    on<ValidatePermissionGalleryEvent>((event, emit) async {
      emit(LoadingImageState());

      String validateStatus;
      validateStatus =
          await ImageProfileController().doValidatePermissionGallery();

      if (validateStatus == "isGranted") {
        emit(const CameraPermissionSuccessState(typePermission: "gallery"));
      }
    });

    on<ValidatePermissionCameraEvent>((event, emit) async {
      emit(LoadingImageState());
      String validateStatus;

      validateStatus =
          await ImageProfileController().doValidatePermissionCamera();

      if (validateStatus == "isGranted") {
        emit(const CameraPermissionSuccessState(typePermission: "camera"));
      }
    });

    on<ConsultPhotoEvent>((event, emit) async {
      bytesImage = await ImageProfileController().doConsultDataImageProfile();
      imagePath = const Base64Encoder().convert(List.from(bytesImage!));



      emit(ImageChangeSuccessState(
          imageBuild: bytesImage, imagePath: imagePath));
    });

    on<SelectDoctorSignature>((event, emit) async {
      emit(LoadingImageState());

      doctorSignatureBuild =
          await ImageProfileController().selectDigitalSignatureByGalleryCtrl();
      doctorSignaturePath =
          const Base64Encoder().convert(List.from(doctorSignatureBuild!));

      emit(ImageChangeSuccessState(
          doctorSignatureBuild: doctorSignatureBuild,
          doctorSignaturePath: doctorSignaturePath));
    });

    on<ConsultDigitalSignatureEvent>((event, emit) async {

      bytesImage = const ImageChangeSuccessState().imageBuild;
      imagePath = const ImageChangeSuccessState().imagePath;

      emit(LoadingImageState());
      doctorSignatureBuild =
          await ImageProfileController().doConsultDigitalSignature();
      doctorSignaturePath =
          const Base64Encoder().convert(List.from(doctorSignatureBuild!));
      emit(ImageChangeSuccessState(
          doctorSignatureBuild: doctorSignatureBuild,
          doctorSignaturePath: doctorSignaturePath,
          imagePath: imagePath,
          imageBuild: bytesImage));
    });
  }
}
