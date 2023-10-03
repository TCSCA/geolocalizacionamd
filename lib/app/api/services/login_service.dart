import '/app/api/mappings/user_mapping.dart';

abstract class LoginService {
  Future<UserMap> doLogin(String user, String password);
  Future<UserMap> resetLogin(String user, String password);
  Future<bool> doLogout(String tokenUser);
}
