import 'package:geolocalizacionamd/app/api/mappings/change_password_mapping.dart';

abstract class ChangePasswordService {
  Future<ChangePasswordMap> doChangePassword(String username, String changePassword);
}