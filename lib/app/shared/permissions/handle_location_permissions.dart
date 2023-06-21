import 'package:location/location.dart';

class HandleLocationPermissions {
  Location location = Location();

  Future<bool> checkLocationService() async {
    late bool isServiceEnabled;

    try {
      isServiceEnabled = await location.serviceEnabled();
      if (!isServiceEnabled) {
        isServiceEnabled = await location.requestService();
      }
    } catch (ex) {
      isServiceEnabled = false;
    }

    return isServiceEnabled;
  }

  Future<bool> checkLocationPermission() async {
    late PermissionStatus permissionGranted;
    late bool isPermissionGranted;

    try {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted == PermissionStatus.granted ||
            permissionGranted == PermissionStatus.grantedLimited) {
          isPermissionGranted = true;
        } else {
          isPermissionGranted = false;
        }
      } else {
        if (permissionGranted == PermissionStatus.granted ||
            permissionGranted == PermissionStatus.grantedLimited) {
          isPermissionGranted = true;
        } else {
          isPermissionGranted = false;
        }
      }
    } catch (e) {
      isPermissionGranted = false;
    }

    return isPermissionGranted;
  }
}
