import 'dart:convert';

import 'package:geolocalizacionamd/app/api/constants/api_constants.dart';
import 'package:geolocalizacionamd/app/api/mappings/reason_rejection_mapping.dart';
import 'package:geolocalizacionamd/app/errors/error_app_exception.dart';
import 'package:geolocalizacionamd/app/errors/error_general_exception.dart';

import 'reason_rejection_service.dart';
import 'package:http/http.dart' as http;

class ReasonRejectionImp implements ReasonRejectionService {
  @override
  Future<ReasonRejectionMapping> getReasonRejection(
      final String tokenUser) async {
    late ReasonRejectionMapping responseRejection;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApi = Uri.parse(ApiConstants.urlApiReasonRejection);
    final Map<String, String> headerRejection = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };

    try {
      responseApi = await http.get(urlApi, headers: headerRejection);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        responseRejection = ReasonRejectionMapping.fromJson(decodeRespApi);
      } else {
        throw ErrorAppException(
            message: decodeRespApi[ApiConstants.dataLabelApi]);
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return responseRejection;
  }
}
