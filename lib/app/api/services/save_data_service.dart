import 'package:geolocalizacionamd/app/core/models/reject_amd_model.dart';

import '/app/api/mappings/home_service_mapping.dart';
import '/app/core/models/connect_doctor_model.dart';

abstract class SaveDataService {
  Future<bool> onConnectDoctorAmd(
      final ConnectDoctorModel requestConnect, final String tokenUser);
  Future<bool> onDisconectDoctorAmd(final String tokenUser);
  Future<HomeServiceMap> onConfirmHomeService(
      final String tokenUser, final int idHomeService);
  Future<bool> onRejectHomeService(
      final String tokenUser, final int idHomeService);
  Future<bool> onCompleteHomeService(
      final String tokenUser, final RejectAmdModel requestReject);
}
