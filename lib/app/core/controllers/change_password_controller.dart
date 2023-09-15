import 'package:geolocalizacionamd/app/api/mappings/change_password_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/change_password_service.dart';
import 'package:geolocalizacionamd/app/api/services/change_password_service_implement.dart';

import '../../errors/error_active_connection.dart';
import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';
import '../models/change_password_model.dart';

class ChangePasswordController {
  final ChangePasswordService changePasswordService =
  ChangePasswordServiceImp();

  Future<ChangePasswordModel> doChangePassword(
      String username, String newPassword) async {
    late ChangePasswordModel changePasswordModel;
    late ChangePasswordMap changePasswordMap;

    try {
      changePasswordMap =
      await changePasswordService.doChangePassword(username, newPassword);

      changePasswordModel = ChangePasswordModel(
          status: changePasswordMap.status, data: changePasswordMap.data);
    } on ErrorAppException {
      rethrow;
    } on ActiveConnectionException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return changePasswordModel;
  }
}