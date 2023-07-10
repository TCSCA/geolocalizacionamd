import 'package:geolocalizacionamd/app/api/mappings/profile_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/consult_data_service_implement.dart';
import 'package:geolocalizacionamd/app/core/controllers/secure_storage_controller.dart';
import 'package:geolocalizacionamd/app/core/models/profile_model.dart';

import '../../api/constants/api_constants.dart';
import '../../api/services/consult_data_service.dart';

class ProfileController {
  final ConsultDataService consultDataService = ConsultDataServiceImp();
  final SecureStorageController secureStorageController =
      SecureStorageController();

  late ProfileModel profileModel;
  late ProfileMap profileMap;

  Future<ProfileModel> doGeProfileController() async {
    final tokenUser =
        await secureStorageController.readSecureData(ApiConstants.tokenLabel);

    profileMap = await consultDataService.getProfile(tokenUser);

    final variable =  profileMap.data?.medicalLicense?.split('|');


    profileModel = ProfileModel(
      fullName: profileMap.data?.fullName,
      identificationDocument: profileMap.data?.identificationDocument,
      email: profileMap.data?.email,
     // birthday: profileMap.data.birthday,
      phoneNumber: profileMap.data?.phoneNumber,
      otherNumber: profileMap.data?.otherNumber,
      city: profileMap.data?.city,
      state: profileMap.data?.state,
      country: profileMap.data?.country,
      direction: profileMap.data?.direction,
      speciality: profileMap.data?.speciality,

    );


    return profileModel;
  }
}
