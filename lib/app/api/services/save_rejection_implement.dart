import 'dart:convert';

import 'package:geolocalizacionamd/app/api/constants/api_constants.dart';
import 'package:geolocalizacionamd/app/api/services/save_rejection_service.dart';
import 'package:geolocalizacionamd/app/errors/error_app_exception.dart';
import 'package:geolocalizacionamd/app/errors/error_general_exception.dart';

import '../mappings/success_save_rejection_mapping.dart';
import 'reason_rejection_service.dart';
import 'package:http/http.dart' as http;

class SaveRejectionImp implements SaveRejectionService {
  @override
  Future<SaveRejectionModel> saveRejectionService(
    String tokenUser,
    String comment,
    int idHomeServiceAttention,
    int idReasonReject,
  ) async {
    late SaveRejectionModel responseRejection;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApi = Uri.parse(ApiConstants.urlApiRejectHomeServiceAttention);
    final Map<String, String> headerRejection = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };

    final String body = jsonEncode({
      'comment': comment,
      'idHomeServiceAttention': idHomeServiceAttention,
      'idReasonReject': idReasonReject,
    });
    try {
      responseApi = await http.post(
        urlApi,
        headers: headerRejection,
        body: body,
      );
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        responseRejection = SaveRejectionModel.fromJson(decodeRespApi);
      } else {
        throw ErrorAppException(
            message: decodeRespApi[ApiConstants.dataLabelApi]);
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }
    return {'', 'fds'} as SaveRejectionModel;
  }
}
