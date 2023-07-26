import 'package:geolocalizacionamd/app/api/mappings/profile_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/consult_data_service_implement.dart';
import 'package:geolocalizacionamd/app/core/controllers/secure_storage_controller.dart';
import 'package:geolocalizacionamd/app/core/models/profile_model.dart';

import '../../api/constants/api_constants.dart';
import '../../api/services/consult_data_service.dart';
import '../../errors/error_active_connection.dart';
import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';

class ProfileController {
  final ConsultDataService consultDataService = ConsultDataServiceImp();
  final SecureStorageController secureStorageController =
      SecureStorageController();

  late ProfileModel profileModel;
  late ProfileMap profileMap;

  Future<ProfileModel> doGeProfileController() async {
    final tokenUser =
        await secureStorageController.readSecureData(ApiConstants.tokenLabel);

    try {
      profileMap = await consultDataService.getProfile(tokenUser);

      final mppsAndmc = profileMap.data?.medicalLicense?.split('|');
      final String mpps = mppsAndmc?[0] ?? '';
      final String mc = mppsAndmc?.length == 2 ? mppsAndmc![1] :'';
      final int realMonth = profileMap.data!.birthday!.month! + 1;

      final day = profileMap.data!.birthday!.dayOfMonth! < 10
          ? '0${profileMap.data!.birthday!.dayOfMonth!}'
          : profileMap.data!.birthday!.dayOfMonth.toString();

      final month = realMonth < 10
          ? '0$realMonth'
          : realMonth.toString();

      profileModel = ProfileModel(
        fullName: profileMap.data?.fullName,
        identificationDocument: profileMap.data?.identificationDocument,
        email: profileMap.data?.email,
        gender: profileMap.data?.gender,
        dayBirthday: day,
        monthBirthday: month,
        yearBirthday: profileMap.data?.birthday?.year.toString(),
        phoneNumber: profileMap.data?.phoneNumber,
        otherNumber: profileMap.data?.otherNumber,
        city: profileMap.data?.city,
        state: profileMap.data?.state,
        country: profileMap.data?.country,
        direction: profileMap.data?.direction,
        speciality: profileMap.data?.speciality,
        medicalLicense: profileMap.data?.medicalLicense,
        mpps: mpps,
        mc: mc
      );
    } on ErrorAppException {
      rethrow;
    } on ActiveConnectionException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return profileModel;
  }
}
