import 'package:flutter/foundation.dart';
import 'package:geolocalizacionamd/app/api/mappings/home_service_mapping.dart';
import 'package:geolocalizacionamd/app/api/mappings/register_date_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/consult_data_service.dart';
import 'package:geolocalizacionamd/app/api/services/consult_data_service_implement.dart';
import 'package:geolocalizacionamd/app/core/models/home_service_model.dart';

import '../../api/constants/api_constants.dart';
import '../../api/services/login_service.dart';
import '../../api/services/login_service_implement.dart';
import '../../api/services/websocket_service.dart';
import '../../api/services/websocket_service_implement.dart';
import '../../errors/error_active_connection.dart';
import '../../errors/exceptions.dart';
import '../models/user_model.dart';
import 'secure_storage_controller.dart';

class LoginController {
  final LoginService loginService = LoginServiceImp();
  final WebSocketService webSocketService = WebSocketServiceImp();
  final SecureStorageController secureStorageController =
      SecureStorageController();
  final ConsultDataService consultDataService = ConsultDataServiceImp();

  Future<UserModel> doLoginUser(
      final String user, final String password) async {
    late UserModel userResponse;

    try {
      var responseLogin = await loginService.doLogin(user, password);

      await secureStorageController.writeSecureData(
          ApiConstants.tokenLabel, responseLogin.data);
      await secureStorageController.writeSecureData(
          ApiConstants.doctorInAttentionLabel, 'false');

      userResponse = UserModel(
          user, responseLogin.descriptionEs, responseLogin.idProfile, []);
    } on ErrorAppException {
      rethrow;
    } on ActiveConnectionException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }
    return userResponse;
  }

  Future doLogoutUser() async {
    bool respWebSocket;

    try {
      final tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);
      if (kDebugMode) {
        print('doLogoutUser tokenUser: $tokenUser');
      }
      respWebSocket = await loginService.doLogout(tokenUser);
      if (!respWebSocket) {
        throw ErrorGeneralException();
      }
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    } finally {
      await secureStorageController.deleteSecureData(ApiConstants.tokenLabel);
      await secureStorageController
          .deleteSecureData(ApiConstants.doctorInAttentionLabel);
      await secureStorageController
          .deleteSecureData(ApiConstants.idHomeServiceConfirmedLabel);
    }

    return respWebSocket;
  }

  Future<UserModel> doResetLoginUser(String user, final String password) async {
    late UserModel userResponse;
    try {
      var responseLogin = await loginService.resetLogin(user, password);

      await secureStorageController.writeSecureData(
          ApiConstants.tokenLabel, responseLogin.data);
      await secureStorageController.writeSecureData(
          ApiConstants.doctorInAttentionLabel, 'false');
      userResponse = UserModel(
          user, responseLogin.descriptionEs, responseLogin.idProfile, []);
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return userResponse;
  }

  /*Solo para pruebas y mostrar el key desde en login, se debe quitar luego*/
  Future<String> getFirebaseKey() async {
    late String response;
    try {
      response = await secureStorageController
          .readSecureData(ApiConstants.tokenFirebaseLabel);
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return response;
  }
}
