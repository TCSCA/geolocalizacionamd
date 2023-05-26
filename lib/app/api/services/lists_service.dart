import '../mappings/menu_mapping.dart';

abstract class ListsService {
  Future<List<MenuMap>> getMenu();
}
