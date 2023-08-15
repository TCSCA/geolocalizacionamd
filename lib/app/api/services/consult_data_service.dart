import 'dart:typed_data';

import '../mappings/gender_mapping.dart';
import '/app/api/mappings/home_service_mapping.dart';
import '/app/api/mappings/photo_mapping.dart';
import '/app/api/mappings/profile_mapping.dart';

abstract class ConsultDataService {
  Future<PhotoMap> getPhotos(final String tokenUser);
  Future<HomeServiceMap> getActiveAmdOrder(final String tokenUser);
  Future<ProfileMap> getProfile(String tokenUser);
  Future<void> validateIfOrderIsCompletedOrRejected(
      String tokenUser, int idHomeServiceAttention);
  Future<List<HomeServiceMap>> getHistoryAmdOrderList(String tokenUser, int idDoctorAmd);
  Future<GenderMap> getAllGender();
  Future<Uint8List?>getPhotoService(String tokenUser);
  Future<Uint8List?>getDigitalSignatureService(String tokenUser);
}
