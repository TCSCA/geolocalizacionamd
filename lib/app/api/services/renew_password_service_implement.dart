import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:geolocalizacionamd/app/api/mappings/renew_password_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/renew_password_service.dart';

import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';
import '../constants/api_constants.dart';

class RenewPasswordServiceImp implements RenewPasswordService {
  @override
  Future<RenewPasswordMap> doRenewPassword(String username) async {
    const headerLogger = 'ListsService.getMenu';
    Map<String, dynamic> decodeResp;
    http.Response responseApi;
    RenewPasswordMap renewPasswordData;

    final Uri urlApiLogin = Uri.parse(ApiConstants.urlApiLogin);

    final String bodyRenewPassword = jsonEncode({'username': username});

    final Map<String, String> headerRenewPassword = {
      'platform': 'APP',
      'Content-Type': 'application/json',
      'apiKeyGpsSHA': 'ShA.GpS.123.'
    };

    try {
      responseApi = await http.post(
        Uri.parse('https://desa.your24sevendoc.com/homeService/api/forgotPassword'),
        headers:  headerRenewPassword,
        body: bodyRenewPassword
      );

      decodeResp = json.decode(responseApi.body);

      renewPasswordData = RenewPasswordMap.fromJson(decodeResp);

    } on ErrorAppException catch (errorapp) {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return renewPasswordData;
  }
}
