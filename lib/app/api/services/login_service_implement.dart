import 'dart:convert';
import 'package:geolocalizacionamd/app/api/interceptors/http_error_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_http.dart';
import '/app/errors/error_active_connection.dart';
import '/app/errors/exceptions.dart';
import '/app/api/constants/api_constants.dart';
import '/app/api/mappings/user_mapping.dart';
import 'login_service.dart';

class LoginServiceImp implements LoginService {
  @override
  Future<UserMap> doLogin(String user, String password) async {
    late UserMap responseUser;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiLogin = Uri.parse(ApiConstants.urlApiLogin);
    final String bodyLogin =
        jsonEncode({'username': user, 'password': password});
    final Map<String, String> headerLogin = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerApiKey: ApiConstants.headerValorApiKey,
      ApiConstants.headerPlataforma: ApiConstants.plataformaApp
    };

    try {
      responseApi =
          await http.post(urlApiLogin, headers: headerLogin, body: bodyLogin);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        if (decodeRespApi['data'] == 'recuperar contraseña') {
          throw ErrorAppException(message: decodeRespApi['data']);
        } else {
          responseUser = UserMap.fromJson(decodeRespApi);
        }
      } else {
        final String error =
            decodeRespApi[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
        if (error == ApiConstants.activeConnectionCodeApi) {
          throw ActiveConnectionException(message: error);
        } else {
          throw ErrorAppException(message: error);
        }
      }
    } on ErrorAppException {
      rethrow;
    } on ActiveConnectionException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return responseUser;
  }

  @override
  Future<UserMap> resetLogin(String user, String password) async {
    late UserMap responseUser;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiResetLogin = Uri.parse(ApiConstants.urlApiResetLogin);
    final String bodyLogin =
        jsonEncode({'username': user, 'password': password});
    final Map<String, String> headerLogin = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerApiKey: ApiConstants.headerValorApiKey,
      ApiConstants.headerPlataforma: ApiConstants.plataformaApp
    };

    try {
      responseApi = await http.post(urlApiResetLogin,
          headers: headerLogin, body: bodyLogin);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        responseUser = UserMap.fromJson(decodeRespApi);
      } else {
        final String error =
            decodeRespApi[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
        throw ErrorAppException(message: error);
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return responseUser;
  }

  @override
  Future<bool> doLogout(String tokenUser) async {
    bool isDisconnect = false;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiLogout = Uri.parse(ApiConstants.urlApiLogout);
    final Map<String, String> headerLogout = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };

    try {
      final http =
          InterceptedHttp.build(interceptors: [HttpErrorInterceptor()]);
      responseApi = await http.post(urlApiLogout, headers: headerLogout);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        isDisconnect = true;
      } else {
        final String error =
            decodeRespApi[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
        throw ErrorAppException(message: error);
      }
    } on ErrorAppException {
      rethrow;
    } on SessionExpiredException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return isDisconnect;
  }
}
