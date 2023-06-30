import 'package:geolocalizacionamd/app/api/mappings/city_mapping.dart';
import 'package:geolocalizacionamd/app/api/mappings/state_mapping.dart';

import '../mappings/menu_mapping.dart';

abstract class ListsService {
  Future<List<MenuMap>> getMenu();
  Future<List<StateMap>> getAllStates(final String idCountry);
  Future<List<CityMap>> getAllCities(final String idState);
}
