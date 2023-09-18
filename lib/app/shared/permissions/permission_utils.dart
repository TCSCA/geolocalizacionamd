import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  Future<bool> getCameraPermissionStatus() async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> askForPermission() async {
    Map<Permission, PermissionStatus> status = await [
      Permission.camera,
    ].request();

    if (status[Permission.camera]!.isGranted) {
      return true;
    }
    return false;
  }
}
