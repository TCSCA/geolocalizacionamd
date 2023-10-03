
import '../mappings/renew_password_mapping.dart';

abstract class RenewPasswordService {
  Future<RenewPasswordMap> doRenewPassword(String username);
}