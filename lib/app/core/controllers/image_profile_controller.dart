import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageProfileController {
  XFile? imagee;

  selectImageByCameraCtrl() async {
    Uint8List? bytesImage;
    String? imagePath;

    imagee = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imagee != null) {
      final _path = imagee!.path.toLowerCase();
      final _imageCheck = _path.endsWith('.jpg') ||
          _path.endsWith('.jpeg') ||
          _path.endsWith('.png');
      //final _imageSize = (await imagee!.length()) / 1000;
    bytesImage = await _cropImage(imagee!.path);
    //imageRaw = await imagee!.readAsBytes();
    print(await imagee!.length());
  }

   return bytesImage;
  }


  _cropImage(filePath) async {
    Uint8List? _bytesImage;

    final imgCrop = ImageCropper();
    CroppedFile? croppedImage = await imgCrop.cropImage(
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
      _bytesImage = await croppedImage.readAsBytes();

    }

    return _bytesImage;
  }

}