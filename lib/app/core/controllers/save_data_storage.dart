import '/app/core/controllers/secure_storage_controller.dart';
import '/app/api/constants/api_constants.dart';

class SaveDataStorage {
  final SecureStorageController secureStorageController =
      SecureStorageController();

  Future writeDataStorage(String dataValue) async {
    secureStorageController.writeSecureData(
        ApiConstants.tokenFirebaseLabel, dataValue);
  }
}
