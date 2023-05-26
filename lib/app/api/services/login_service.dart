import '../mappings/user_mapping.dart';

abstract class LoginService {
  Future<UserMap> doLogin(String user, String password);
  Future<bool> resetLogin(String user);
}
