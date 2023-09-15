import 'package:geolocalizacionamd/app/api/mappings/change_password_mapping.dart';

import 'change_password_service_implement.dart';

abstract class ChangePasswordService {

  Future<ChangePasswordMap> doChangePassword(String username, String changePassword);

}