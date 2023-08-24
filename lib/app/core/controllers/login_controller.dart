import 'package:flutter/foundation.dart';
import '/app/api/services/consult_data_service.dart';
import '/app/api/services/consult_data_service_implement.dart';
import '/app/api/constants/api_constants.dart';
import '/app/api/services/login_service.dart';
import '/app/api/services/login_service_implement.dart';
import '/app/errors/error_active_connection.dart';
import '/app/errors/exceptions.dart';
import '/app/core/models/user_model.dart';
import 'secure_storage_controller.dart';

class LoginController {
  final LoginService loginService = LoginServiceImp();
  final SecureStorageController secureStorageController =
      SecureStorageController();
  final ConsultDataService consultDataService = ConsultDataServiceImp();

  Future<UserModel> doLoginUser(
      final String user, final String password) async {
    late UserModel userResponse;

    try {
     // ImageProfileBloc? imageProfileBloc = ImageProfileBloc();

      var responseLogin = await loginService.doLogin(user, password);

      cleanDataSession();
      await secureStorageController.writeSecureData(
          ApiConstants.tokenLabel, responseLogin.data);
      await secureStorageController.writeSecureData(
          ApiConstants.doctorInAttentionLabel, 'false');
      await secureStorageController.writeSecureData(
          ApiConstants.idDoctorAmd, responseLogin.user.toString());

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
      cleanDataSession();
    }
    return respWebSocket;
  }

  Future<UserModel> doResetLoginUser(String user, final String password) async {
    late UserModel userResponse;
    try {
      cleanDataSession();

      var responseLogin = await loginService.resetLogin(user, password);

      await secureStorageController.writeSecureData(
          ApiConstants.tokenLabel, responseLogin.data);
      await secureStorageController.writeSecureData(
          ApiConstants.doctorInAttentionLabel, 'false');
      await secureStorageController.writeSecureData(
          ApiConstants.idDoctorAmd, responseLogin.user.toString());

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

  Future<bool> validateConnectedDoctor() async {
    bool newBoolValue = false;
    String connectedDoctor = await secureStorageController
        .readSecureData(ApiConstants.doctorConnectedLabel);
    if (connectedDoctor.isNotEmpty) {
      newBoolValue = connectedDoctor.toLowerCase() != 'false';
    }
    return newBoolValue;
  }

  Future<void> cleanDataSession() async {
    await secureStorageController
        .deleteSecureData(ApiConstants.doctorInAttentionLabel);
    await secureStorageController.deleteSecureData(ApiConstants.idDoctorAmd);
    await secureStorageController
        .deleteSecureData(ApiConstants.doctorConnectedLabel);
    await secureStorageController
        .deleteSecureData(ApiConstants.doctorAmdAssignedLabel);
    await secureStorageController
        .deleteSecureData(ApiConstants.idAmdconfirmedLabel);
  }
}
