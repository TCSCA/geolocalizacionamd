import '/app/api/constants/api_constants.dart';
import '/app/errors/exceptions.dart';
import '/app/core/controllers/secure_storage_controller.dart';
import '/app/core/models/photo_model.dart';
import '/app/api/services/consult_data_service.dart';
import '/app/api/services/consult_data_service_implement.dart';

class PhotoController {
  final ConsultDataService consultDataService = ConsultDataServiceImp();
  final SecureStorageController secureStorageController =
      SecureStorageController();

  Future<PhotoModel> getPhotoUser() async {
    late PhotoModel photoResponse;

    try {
      var tokenUser =
          secureStorageController.readSecureData(ApiConstants.tokenLabel);
      var responsePhoto =
          await consultDataService.getPhotos(tokenUser.toString());
      if (responsePhoto.photoProfile.isNotEmpty) {
        photoResponse = PhotoModel(responsePhoto.photoProfile);
      } else {}
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return photoResponse;
  }
}
