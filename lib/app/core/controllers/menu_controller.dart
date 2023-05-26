import '/app/errors/exceptions.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/core/models/menu_model.dart';
import '/app/api/services/lists_service_implement.dart';
import '/app/api/services/lists_service.dart';

class MenuAppController {
  final ListsService listsService = ListsServiceImp();

  Future<List<MenuModel>> getListMenu(String languageCode) async {
    List<MenuModel> listMenu = [], listSubMenu = [];
    late MenuModel opMenu;
    late String descOpcion;

    try {
      var opcionesMenu = await listsService.getMenu();

      for (var opcion in opcionesMenu) {
        listSubMenu = [];
        descOpcion = '';

        if (opcion.enable) {
          descOpcion = languageCode.toLowerCase() ==
                  AppConstants.languageCodeEs.toLowerCase()
              ? opcion.descripcionEs
              : opcion.descripcionEn;
          opMenu = MenuModel(opcion.id, descOpcion, opcion.icon, opcion.route,
              opcion.parent, listSubMenu);
          listMenu.add(opMenu);
        }
      }

      if (listMenu.isEmpty) {
        throw ErrorGeneralException();
      }
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return listMenu;
  }
}
