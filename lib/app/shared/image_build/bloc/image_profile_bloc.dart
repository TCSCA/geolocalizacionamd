import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/controllers/camera_controller.dart';
import 'package:geolocalizacionamd/app/core/controllers/image_profile_controller.dart';
import 'package:geolocalizacionamd/app/shared/image_build/camera_enums.dart';
import 'package:geolocalizacionamd/app/shared/permissions/permission_utils.dart';

import '../../../errors/error_app_exception.dart';
import '../../../errors/error_general_exception.dart';
import '../../../errors/error_session_expired.dart';
import '../../../pages/constants/app_constants.dart';

part 'image_profile_event.dart';

part 'image_profile_state.dart';

class ImageProfileBloc extends Bloc<ImageProfileEvent, ImageProfileState> {
  Uint8List? bytesImage;
  String? imagePath;

  Uint8List? doctorSignatureBuild;
  String? doctorSignaturePath;
  PermissionUtils? permissionUtils = PermissionUtils();
  CameraUtils? cameraCtrl = CameraUtils();

  ImageProfileBloc() : super(const InitialImageProfileState()) {
    on<ImageProfileEvent>((event, emit) {});

    on<ImageProfileInitialEvent>((event, emit) {
      String imagePathSave =
          const Base64Encoder().convert(List.from(event.imageBuild!));
      emit(InitialImageProfileState(
          imageBuild: event.imageBuild, imagePath: imagePathSave));
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

      try {
        validateStatus =
            await ImageProfileController().doValidatePermissionGallery();

        if (validateStatus == "isGranted") {
          emit(const CameraPermissionSuccessState(typePermission: "gallery"));
        }
      } on ErrorAppException catch (exapp) {
        emit(ImageErrorState(messageError: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(ImageErrorState(messageError: exgen.message));
      } on SessionExpiredException catch (exgen) {
        emit(ImageErrorState(messageError: exgen.message));
      } catch (unknowerror) {
        emit(const ImageErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ValidatePermissionCameraEvent>((event, emit) async {
      emit(LoadingImageState());
      String validateStatus;

      try {
        validateStatus =
            await ImageProfileController().doValidatePermissionCamera();

        if (validateStatus == "isGranted") {
          emit(const CameraPermissionSuccessState(typePermission: "camera"));
        }
      } on ErrorAppException catch (exapp) {
        emit(ImageErrorState(messageError: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(ImageErrorState(messageError: exgen.message));
      } on SessionExpiredException catch (exgen) {
        emit(ImageErrorState(messageError: exgen.message));
      } catch (unknowerror) {
        emit(const ImageErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ConsultPhotoEvent>((event, emit) async {
      bytesImage = await ImageProfileController().doConsultDataImageProfile();
      imagePath = const Base64Encoder().convert(List.from(bytesImage!));

      emit(InitialImageProfileState(
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

    on<CameraEnable>(_onCameraEnable);
    on<CameraSwitch>(_onCameraSwitch);
    on<CameraTakePicture>(_onCameraTakePicture);
    on<CameraReset>(_onCameraReset);
    on<CameraDisable>(_onCameraDisable);
  }

  // Handle CameraReset event
  void _onCameraReset(
      CameraReset event, Emitter<ImageProfileState> emit) async {
    await cameraCtrl?.disposeCamera(); // Dispose of the camera before resetting
    cameraCtrl?.resetCameraBloc(); // Reset the camera BLoC state
    emit(CameraInitial(
        cameraController:
            cameraCtrl!.cameraController!)); // Emit the initial state
  }

  // Handle CameraSwitch event
  void _onCameraSwitch(
      CameraSwitch event, Emitter<ImageProfileState> emit) async {
    //  emit(CameraInitial());
    await cameraCtrl?.switchCamera();
    emit(CameraInitial(cameraController: cameraCtrl!.cameraController!));
  }

  void _onCameraTakePicture(
      CameraTakePicture event, Emitter<ImageProfileState> emit) async {
    final pickture = await cameraCtrl!.takePictureCamera();
    await cameraCtrl!.disposeCamera();
    //cameraController = null;
    final picturePath = const Base64Encoder().convert(List.from(pickture!));
    emit(ImageChangeSuccessState(imageBuild: pickture, imagePath: picturePath));
  }

  // Handle CameraEnable event on app resume
  void _onCameraEnable(
      CameraEnable event, Emitter<ImageProfileState> emit) async {
    if (!cameraCtrl!.isInitialized()) {
      if (await permissionUtils!.getCameraPermissionStatus()) {
        await cameraCtrl!.checkPermissionAndInitializeCamera();
        cameraCtrl!.cameraController = await cameraCtrl?.initializeCamera();
        emit(CameraInitial(cameraController: cameraCtrl!.cameraController!));
      } else {
        // emit(const CameraError(error: CameraErrorType.permission));
        await permissionUtils!.askForPermission();
        cameraCtrl!.cameraController = await cameraCtrl?.initializeCamera();
        emit(CameraInitial(cameraController: cameraCtrl!.cameraController!));
      }
    } else if (cameraCtrl!.isInitialized()) {
      emit(CameraInitial(cameraController: cameraCtrl!.cameraController!));
    } else {
      emit(const CameraError(error: CameraErrorType.other));
    }
  }

  // Handle CameraDisable event when camera is not in use
  void _onCameraDisable(
      CameraDisable event, Emitter<ImageProfileState> emit) async {
    if (cameraCtrl!.isInitialized()) {
      // if app minimize while recording then save the the video then disable the camera
      //add(CameraRecordingStop());
      await Future.delayed(const Duration(seconds: 2));
    }
    await cameraCtrl?.disposeCamera();
    emit(const InitialImageProfileState());
  }
}
