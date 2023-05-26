import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../errors/error_active_connection.dart';
import '../../errors/exceptions.dart';
import '../constants/api_constants.dart';
import '../mappings/user_mapping.dart';
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
      ApiConstants.headerBiscom: ApiConstants.headerValorBiscom,
      ApiConstants.headerPlataforma: ApiConstants.plataformaApp
    };

    try {
      responseApi =
          await http.post(urlApiLogin, headers: headerLogin, body: bodyLogin);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        responseUser = UserMap.fromJson(decodeRespApi);
      } else {
        if (decodeRespApi[ApiConstants.dataLabelApi] ==
            ApiConstants.activeConnectionCodeApi) {
          throw ActiveConnectionException(
              message: decodeRespApi[ApiConstants.dataLabelApi]);
        } else {
          throw ErrorAppException(
              message: decodeRespApi[ApiConstants.dataLabelApi]);
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
  Future<bool> resetLogin(String user) async {
    late bool responseResetLogin = false;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiResetLogin = Uri.parse(ApiConstants.urlApiResetLogin);
    final String bodyLogin = jsonEncode({'username': user});
    final Map<String, String> headerLogin = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerBiscom: ApiConstants.headerValorBiscom,
      ApiConstants.headerPlataforma: ApiConstants.plataformaApp
    };

    try {
      responseApi = await http.post(urlApiResetLogin,
          headers: headerLogin, body: bodyLogin);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        responseResetLogin = true;
      } else {
        throw ErrorAppException(
            message: decodeRespApi[ApiConstants.dataLabelApi]);
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return responseResetLogin;
  }
}
