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

  Future<UserModel> doLoginUser(
      final String user, final String password) async {
    late UserModel userResponse;

    try {
      var responseLogin = await loginService.doLogin(user, password);
      var responseSocket =
          await webSocketService.onConnect(responseLogin.token);

      if (responseSocket) {
        await secureStorageController.writeSecureData(
            ApiConstants.tokenLabel, responseLogin.token);
        userResponse =
            UserModel(user, responseLogin.perfil, responseLogin.idAffiliate);
      } else {
        throw ErrorGeneralException();
      }
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
      respWebSocket = await webSocketService.onDisconnect();
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
    }

    return respWebSocket;
  }

  Future doResetLoginUser(final String user) async {
    bool respResetLogin;
    try {
      respResetLogin = await loginService.resetLogin(user);
      if (!respResetLogin) {
        throw ErrorGeneralException();
      }
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return respResetLogin;
  }
}
