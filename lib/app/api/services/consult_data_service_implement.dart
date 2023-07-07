import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '/app/api/mappings/home_service_mapping.dart';
import '/app/errors/error_empty_data.dart';
import '/app/api/constants/api_constants.dart';
import '/app/api/mappings/photo_mapping.dart';
import '/app/errors/exceptions.dart';
import 'consult_data_service.dart';

class ConsultDataServiceImp implements ConsultDataService {
  @override
  Future<PhotoMap> getPhotos(final String tokenUser) async {
    late PhotoMap responsePhotos;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiPhotos = Uri.parse(ApiConstants.urlApiPhotos);
    final Map<String, String> headerPhotos = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };

    try {
      responseApi = await http.post(urlApiPhotos, headers: headerPhotos);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        responsePhotos = PhotoMap.fromJson(decodeRespApi);
      } else {
        throw ErrorAppException(
            message: decodeRespApi[ApiConstants.dataLabelApi]);
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return responsePhotos;
  }

  @override
  Future<HomeServiceMap> getActiveAmdOrder(String tokenUser) async {
    late HomeServiceMap responseActiveAmdOrder;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiGetActiveAmdOrder =
        Uri.parse(ApiConstants.urlApiGetActiveAmdOrder);
    final Map<String, String> headerActiveAmdOrder = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };

    try {
      final resp =
          await rootBundle.loadString('assets/data/amd_confirmed.json');
      decodeRespApi = json.decode(resp);

      // responseApi = await http.post(urlApiGetActiveAmdOrder,
      //     headers: headerActiveAmdOrder);
      // decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        if (decodeRespApi[ApiConstants.dataLabelApi] != null) {
          responseActiveAmdOrder = HomeServiceMap.fromJson(decodeRespApi);
        } else {
          throw EmptyDataException(message: 'NODATA');
        }
      } else {
        throw ErrorAppException(
            message: decodeRespApi[ApiConstants.dataLabelApi]);
      }
    } on EmptyDataException {
      rethrow;
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return responseActiveAmdOrder;
  }
}
