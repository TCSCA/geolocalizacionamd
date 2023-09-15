import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:geolocalizacionamd/app/api/mappings/renew_password_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/renew_password_service.dart';

import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';
import '../constants/api_constants.dart';

class RenewPasswordServiceImp implements RenewPasswordService {
  @override
  Future<RenewPasswordMap> doRenewPassword(String username) async {
    Map<String, dynamic> decodeResp;
    http.Response responseApi;
    late RenewPasswordMap renewPasswordData;

    final Uri urlApiForgotPassword =
        Uri.parse(ApiConstants.urlApiForgotPassword);

    final String bodyRenewPassword = jsonEncode({'username': username});

    final Map<String, String> headerRenewPassword = {
      ApiConstants.headerPlataforma: ApiConstants.plataformaApp,
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerApiKey: ApiConstants.headerValorApiKey
    };

    try {
      responseApi = await http.post(
          urlApiForgotPassword,
          headers:  headerRenewPassword,
          body: bodyRenewPassword
      );

      decodeResp = json.decode(responseApi.body);
      if(decodeResp[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        renewPasswordData = RenewPasswordMap.fromJson(decodeResp);
      } else {
        if(decodeResp[ApiConstants.dataLabelApi] == 'MSG-033') {
          throw ErrorAppException(message: decodeResp[ApiConstants.dataLabelApi]);
        } else {
          final String error =
          decodeResp[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
          throw ErrorAppException(message: error);
        }

      }


    } on ErrorAppException catch (errorapp) {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return renewPasswordData;
  }
}