import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocalizacionamd/app/shared/image_build/camera_enums.dart';
import 'package:geolocalizacionamd/app/shared/permissions/permission_utils.dart';
import 'package:image_cropper/image_cropper.dart';

class CameraUtils {
  final PermissionUtils permissionUtils = PermissionUtils();
  CameraController? cameraController;
  CameraLensDirection currentLensDirection = CameraLensDirection.back;
  double minAvailableZoom = 1.0;
  double maxAvailableZoom = 1.0;
  double currentZoomLevel = 1.0;
  FlashMode? currentFlashMode;

  CameraController? getController() => cameraController;
  bool isInitialized() => cameraController?.value.isInitialized ?? false;

  /// Returns a CameraController with the specified configuration.
  Future<CameraController> getCameraController({
    ResolutionPreset resolutionPreset = ResolutionPreset.max,
    required CameraLensDirection lensDirection,
  }) async {
    // Retrieve the list of available cameras on the device
    final cameras = await availableCameras();

    // Find the camera that matches the specified lens direction
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == lensDirection,
      orElse: () => cameras.first, // If not found, default to the first camera
    );

    // Create a CameraController instance with the selected camera and configuration
    return CameraController(
      camera,
      resolutionPreset,
      imageFormatGroup: Platform.isIOS
          ? ImageFormatGroup.yuv420
          : null, // iOS-specific configuration
    );
  }

  // Reset the camera BLoC to its initial state
  Future<void> resetCameraBloc() async {
    currentZoomLevel = 1.0;
    cameraController!.removeListener(() {});
    await cameraController!.dispose();
    initializeCamera();
  }

  Future<void> initFirstCamera() async {
    List<CameraDescription>? cameras;
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
  }

  // Check and ask for camera permission and initialize camera
  Future<void> checkPermissionAndInitializeCamera() async {
    if (await permissionUtils.getCameraPermissionStatus()) {
      await initializeCamera();
    } else {
      if (await permissionUtils.askForPermission()) {
        await initializeCamera();
      } else {
        return Future.error(CameraErrorType
            .permission); // Throw the specific error type for permission denial
      }
    }
  }

  // Initialize the camera controller
  Future<CameraController?> initializeCamera() async {
    cameraController =
        await getCameraController(lensDirection: currentLensDirection);
    try {
      cameraController!.addListener(() {});
      await cameraController!.initialize();
      await Future.wait([
        cameraController!
            .getMaxZoomLevel()
            .then((value) => maxAvailableZoom = value),
        cameraController!
            .getMinZoomLevel()
            .then((value) => minAvailableZoom = value),
      ]);
      return cameraController;
    } on CameraException catch (error) {
      debugPrint(error.toString());
    } catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  Future<Uint8List?>? takePictureCamera() async {
    late Uint8List? photoByte;
    try {
      final XFile? photoFile = await cameraController?.takePicture();
      photoByte = await _crop(photoFile!.path);
      return photoByte!;
    } on CameraException catch (error) {
      Future.error(error);
    } catch (e) {
      Future.error(e);
    }
    return null;
  }

  Future<Uint8List?> _crop(filePath) async {
    Uint8List? bytesImage;
    final imgCrop = ImageCropper();
    CroppedFile? croppedImage;
    try {
      croppedImage = await imgCrop.cropImage(
        compressQuality: 50,
        sourcePath: filePath,
        maxWidth: 500,
        maxHeight: 500,
        compressFormat: ImageCompressFormat.jpg,
        cropStyle: CropStyle.circle,
        aspectRatio: const CropAspectRatio(ratioX: 3.0, ratioY: 3.0),
        uiSettings: <PlatformUiSettings>[
          AndroidUiSettings(
            toolbarTitle: 'Recorte de imagen',
            toolbarColor: Colors.blueGrey,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            hideBottomControls: true,
            showCropGrid: false,
          ),
          IOSUiSettings(
            rotateClockwiseButtonHidden: true,
            rectWidth: 500,
            rectHeight: 500,
            resetButtonHidden: false,
            aspectRatioPickerButtonHidden: true,
            rotateButtonsHidden: false,
          )
        ],
      );
    } catch (err) {
      // print(err);
    }

    if (croppedImage != null) {
      bytesImage = await croppedImage.readAsBytes();
    }
    return bytesImage;
  }

  // Switch between front and back cameras
  Future<void> switchCamera() async {
    currentLensDirection = currentLensDirection == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;
    await reInitialize();
  }

  // Reinitialize the camera
  Future<void> reInitialize() async {
    await disposeCamera();
    await initializeCamera();
  }

  // Dispose of the camera controller
  Future<void> disposeCamera() async {
    cameraController?.removeListener(() {});
    await cameraController?.dispose();
    cameraController = await getCameraController(
      lensDirection: currentLensDirection,
    ); // it's important to remove old camera controller instances otherwise cameraController!.value will remain unchanged hence cameraController!.value.isInitialized will always true
  }
}
