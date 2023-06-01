


import 'package:geolocalizacionamd/app/api/mappings/renew_password_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/renew_password_service.dart';
import 'package:geolocalizacionamd/app/api/services/renew_password_service_implement.dart';
import 'package:geolocalizacionamd/app/core/models/renew_password_model.dart';

import '../../errors/error_active_connection.dart';
import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';

class RenewPasswordController {

  final RenewPasswordService renewPasswordService = RenewPasswordServiceImp();

  Future<RenewPasswordModel?> doRenewPassword(String email) async {
    late RenewPasswordModel renewPasswordModel;
    late RenewPasswordMap? renewPasswordMap;
    try {
      renewPasswordMap = await renewPasswordService.doRenewPassword(email);

      renewPasswordModel = RenewPasswordModel(
          status: renewPasswordMap.status,
          msg: renewPasswordMap.msg,
          data: renewPasswordMap.data
      );
    } on ErrorAppException {
      rethrow;
    } on ActiveConnectionException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return renewPasswordModel;
  }


}