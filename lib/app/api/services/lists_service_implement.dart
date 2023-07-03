import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '/app/api/mappings/city_mapping.dart';
import '/app/api/constants/api_constants.dart';
import '/app/api/mappings/menu_mapping.dart';
import '/app/api/mappings/state_mapping.dart';
import '/app/errors/exceptions.dart';
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

  @override
  Future<List<StateMap>> getAllStates(final String idCountry) async {
    List<StateMap> listStates = [];
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiGetAllStatesByCountry = Uri.parse(ApiConstants
        .urlApiGetAllStatesByCountry
        .replaceAll(RegExp(r'idCountry'), idCountry));
    final Map<String, String> headerGetAllStatesByCountry = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerPlataforma: ApiConstants.plataformaApp,
      ApiConstants.headerApiKey: ApiConstants.headerValorApiKey,
    };

    try {
      responseApi = await http.get(urlApiGetAllStatesByCountry,
          headers: headerGetAllStatesByCountry);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        listStates = List<StateMap>.from(
            decodeRespApi[ApiConstants.dataLabelApi]
                .map((data) => StateMap.fromJson(data)));
      } else {
        throw ErrorAppException(
            message: decodeRespApi[ApiConstants.dataLabelApi]);
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return listStates;
  }

  @override
  Future<List<CityMap>> getAllCities(String idState) async {
    List<CityMap> listCities = [];
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiGetAllCityByState = Uri.parse(ApiConstants
        .urlApiGetAllCityByState
        .replaceAll(RegExp(r'idState'), idState));
    final Map<String, String> headerGetAllCityByState = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerPlataforma: ApiConstants.plataformaApp,
      ApiConstants.headerApiKey: ApiConstants.headerValorApiKey,
    };

    try {
      responseApi = await http.get(urlApiGetAllCityByState,
          headers: headerGetAllCityByState);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        listCities = List<CityMap>.from(decodeRespApi[ApiConstants.dataLabelApi]
            .map((data) => CityMap.fromJson(data)));
      } else {
        throw ErrorAppException(
            message: decodeRespApi[ApiConstants.dataLabelApi]);
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return listCities;
  }
}
