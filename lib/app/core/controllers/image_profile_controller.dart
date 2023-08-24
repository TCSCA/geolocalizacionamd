import 'dart:typed_data';
import 'dart:io';

import 'package:geolocalizacionamd/app/core/controllers/secure_storage_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/constants/api_constants.dart';
import '../../api/services/consult_data_service.dart';
import '../../api/services/consult_data_service_implement.dart';
import '../../errors/error_app_exception.dart';
import '../../errors/error_empty_data.dart';
import '../../errors/error_general_exception.dart';
import '../../errors/error_session_expired.dart';

class ImageProfileController {
  final SecureStorageController secureStorageController =
      SecureStorageController();

  XFile? image;
  final ImagePicker _picker = ImagePicker();
  bool invalidatePermissionCamera = true;
  bool invalidatePermissionStorage = true;

  List validateType = ["isPermanentlyDenied", "isGranted", "isLimit"];

  doConsultDataImageProfile() async {
    Uint8List? imageProfile;

    final ConsultDataService consultDataService = ConsultDataServiceImp();

    final tokenUser =
        await secureStorageController.readSecureData(ApiConstants.tokenLabel);

    imageProfile = await consultDataService.getPhotoService(tokenUser);

    return imageProfile;
  }

  doConsultDigitalSignature() async {
    Uint8List? imageProfile;

    final ConsultDataService consultDataService = ConsultDataServiceImp();

    final tokenUser =
        await secureStorageController.readSecureData(ApiConstants.tokenLabel);

    imageProfile =
        await consultDataService.getDigitalSignatureService(tokenUser);

    return imageProfile;
  }

  doValidatePermissionCamera() async {
    var cameraPermission = await Permission.camera.request();
    String validate = '';

    try {
     /* if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
        int androidVersion = androidInfo.version.sdkInt;

        if (androidVersion < 33) {
          // For Android versions earlier than 12
          cameraPermission = await Permission.storage.request();
          // return await Permission.storage.isGranted;
        } else {
          // For Android 12 and later
          cameraPermission = await Permission.photos.request();
          //  return await Permission.manageExternalStorage.isGranted;
        }
      } else {
        cameraPermission = await Permission.photos.request();
      }*/

      if (cameraPermission == PermissionStatus.permanentlyDenied ||
          cameraPermission == PermissionStatus.restricted) {
        if (invalidatePermissionCamera) {
          validate = validateType[2];
          throw ErrorAppException(message: 'MSGAPP-181');
          //  _importantPermission(S.current.important, S.current.MSG_181, context);
        }
        if (invalidatePermissionCamera == false) {
          invalidatePermissionCamera = true;
        }
      } else if (cameraPermission == PermissionStatus.granted) {
        validate = validateType[1];
        // Either the permission was already granted before or the user just granted it.
      } else if (cameraPermission == PermissionStatus.denied) {
        invalidatePermissionCamera = false;
        validate = validateType[2];
      }
    } on EmptyDataException {
      rethrow;
    } on ErrorAppException {
      rethrow;
    } on SessionExpiredException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }



    return validate;
  }

  doValidatePermissionGallery() async {
    PermissionStatus photoPermission;

    String validate = '';

    try{
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
        int androidVersion = androidInfo.version.sdkInt;

        if (androidVersion < 33) {
          // For Android versions earlier than 12
          photoPermission = await Permission.storage.request();
          // return await Permission.storage.isGranted;
        } else {
          // For Android 12 and later
          photoPermission = await Permission.photos.request();
          //  return await Permission.manageExternalStorage.isGranted;
        }
      } else {
        photoPermission = await Permission.photos.request();
      }

      if (photoPermission == PermissionStatus.granted ||
          photoPermission == PermissionStatus.limited) {
        validate = validateType[1];
      } else if (photoPermission == PermissionStatus.permanentlyDenied ||
          photoPermission == PermissionStatus.restricted) {
        if (invalidatePermissionStorage) {
          validate = validateType[2];
          throw ErrorAppException(message: 'MSGAPP-181');
          // _importantPermission(S.current.important, S.current.MSG_181, context);
        }
        if (!invalidatePermissionStorage) {
          invalidatePermissionStorage = true;
        }
      } else if (photoPermission == PermissionStatus.denied) {
        invalidatePermissionStorage = false;
        validate = validateType[0];
      }

    } on EmptyDataException {
      rethrow;
    } on ErrorAppException {
      rethrow;
    } on SessionExpiredException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }
    return validate;
  }

  selectImageByCameraCtrl() async {
    Uint8List? bytesImage = null;

    image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
    
      bytesImage = await _cropImage(image!.path);

      print(await image!.length());
    }

    return bytesImage;
  }

  selectImageByGalleryCtrl() async {
    Uint8List? bytesImage = null;

    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {


      bytesImage = await _cropImage(image!.path);

    }
    return bytesImage;
  }

  selectDigitalSignatureByGalleryCtrl() async {
    Uint8List? bytesSignature = null;
    XFile? imageSignature;
    final ImagePicker pickerSignature = ImagePicker();

    imageSignature = await pickerSignature.pickImage(source: ImageSource.gallery);

    if (imageSignature != null) {
      final pathSignature = imageSignature.path;
      bytesSignature = await _cropSignature(pathSignature);
    }
    return bytesSignature;
  }

  _cropImage(filePath) async {
    Uint8List? bytesImage;

    final imgCrop = ImageCropper();
    CroppedFile? croppedImage = await imgCrop.cropImage(
      compressQuality: 25,
      sourcePath: filePath,
      maxWidth: 500,
      maxHeight: 500,
      compressFormat: ImageCompressFormat.jpg,
      cropStyle: CropStyle.circle,
      aspectRatio: const CropAspectRatio(ratioX: 2.0, ratioY: 2.0),
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: 'Recorte de imagen',
          toolbarColor: Colors.blueGrey,
          toolbarWidgetColor: Colors.white,
          // initAspectRatio: CropAspectRatioPreset.original,
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
            rotateButtonsHidden: false)
      ],
    );
    if (croppedImage != null) {
      bytesImage = await croppedImage.readAsBytes();
    }

    return bytesImage;
  }

  _cropSignature(filePath) async {
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
        cropStyle: CropStyle.rectangle,
        aspectRatio: const CropAspectRatio(ratioX: 5.5, ratioY: 3.0),
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
              rotateButtonsHidden: false)
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
}
