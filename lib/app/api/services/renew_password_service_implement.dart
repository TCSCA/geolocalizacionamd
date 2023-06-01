
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:geolocalizacionamd/app/api/mappings/renew_password_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/renew_password_service.dart';

import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';

class RenewPasswordServiceImp implements RenewPasswordService {


  @override
  Future<RenewPasswordMap> doRenewPassword(String email) async {
    const headerLogger = 'ListsService.getMenu';
    Map<String, dynamic> decodeResp;
     RenewPasswordMap renewPasswordData;

    try {
      final resp = await rootBundle.loadString('assets/data/renew_password.json');
      decodeResp = json.decode(resp);

      renewPasswordData = RenewPasswordMap.fromJson(decodeResp);
    } on ErrorAppException catch (errorapp) {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return renewPasswordData;
  }

}