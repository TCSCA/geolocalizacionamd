import '/app/api/mappings/home_service_mapping.dart';
import '/app/core/models/connect_doctor_model.dart';
import '/app/core/models/reject_amd_model.dart';

abstract class SaveDataService {
  Future<bool> onConnectDoctorAmd(
      final ConnectDoctorModel requestConnect, final String tokenUser);

  Future<bool> onDisconectDoctorAmd(final String tokenUser);

  Future<HomeServiceMap> onConfirmHomeService(
      final String tokenUser, final int idHomeService);

  Future<bool> onRejectHomeService(
      final String tokenUser, final RejectAmdModel requestReject);

  Future<bool> onCompleteHomeService(
      final String tokenUser, final RejectAmdModel requestReject);

  Future<bool> editProfileService(
      int idAffiliate,
      String fullName,
      String email,
      String dateOfBirth,
      int idGender,
      String phoneNumber,
      String? otherPhone,
      int idCountry,
      int idState,
      int idCity,
      String direction,
      int mpps,
      int cm,
      String speciality,
      String? photoProfile,
      String? digitalSignature,
      String tokenUser);

  Future<void> renewAmdFormService(int idMedicalOrder, String tokenUser);
}

