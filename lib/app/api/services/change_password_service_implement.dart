import 'dart:convert';

import 'package:geolocalizacionamd/app/api/constants/api_constants.dart';
import 'package:geolocalizacionamd/app/api/mappings/change_password_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/change_password_service.dart';
import 'package:http/http.dart' as http;

import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';

class ChangePasswordServiceImp implements ChangePasswordService {
  @override
  Future<ChangePasswordMap> doChangePassword(
      String username, String newPassword) async {
    Map<String, dynamic> decodeResp;
    http.Response responseApi;

    ///TODO: falta el modelo y el Map.
    ChangePasswordMap changePasswordMap;

    final Uri urlChangePassword = Uri.parse(ApiConstants.urlApiChangePassword);

    final String bodyChangePassword =
        jsonEncode({'username': username, 'newPassword': newPassword});

    final Map<String, String> headerChangePassword = {
      'platform': 'APP',
      'Content-Type': 'application/json',
      'apiKeyGpsSHA': 'ShA.GpS.123.'
    };

    try {
      responseApi = await http.post(urlChangePassword,
          headers: headerChangePassword, body: bodyChangePassword);

      decodeResp = jsonDecode(responseApi.body);

      changePasswordMap = ChangePasswordMap.fromJson(decodeResp);
    } on ErrorAppException catch (errorapp) {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return changePasswordMap;
  }
}
