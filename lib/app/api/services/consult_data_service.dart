import '/app/api/mappings/home_service_mapping.dart';
import '/app/api/mappings/photo_mapping.dart';

abstract class ConsultDataService {
  Future<PhotoMap> getPhotos(final String tokenUser);
  Future<HomeServiceMap> getActiveAmdOrder(final String tokenUser);
}
