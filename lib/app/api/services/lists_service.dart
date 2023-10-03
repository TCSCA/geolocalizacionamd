import '/app/api/mappings/city_mapping.dart';
import '/app/api/mappings/state_mapping.dart';
import '/app/api/mappings/menu_mapping.dart';
import '/app/api/mappings/reason_rejection_mapping.dart';

abstract class ListsService {
  Future<List<MenuMap>> getMenu();
  Future<List<StateMap>> getAllStates(final String idCountry);
  Future<List<CityMap>> getAllCities(final String idState);
  Future<List<ReasonRejectionMap>> getAllReasonRejection(
      final String tokenUser);
}
