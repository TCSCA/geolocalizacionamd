import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocalizacionamd/app/api/mappings/menu_mapping.dart';
import '../../errors/exceptions.dart';
import 'lists_service.dart';

class ListsServiceImp implements ListsService {
  @override
  Future<List<MenuMap>> getMenu() async {
    Map<String, dynamic> decodeResp;
    List<MenuMap> opciones = [];
    try {
      final resp = await rootBundle.loadString('assets/data/menu_opts.json');
      decodeResp = json.decode(resp);
      opciones = List<MenuMap>.from(
          decodeResp['opciones'].map((data) => MenuMap.fromJson(data)));
      opciones.sort((a, b) => a.order.compareTo(b.id));
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return opciones;
  }
}
