import 'dart:convert';
import 'package:geolocalizacionamd/app/api/mappings/home_service_mapping.dart';
import 'package:geolocalizacionamd/app/core/models/connect_doctor_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocalizacionamd/app/api/constants/api_constants.dart';
import 'package:geolocalizacionamd/app/api/services/save_data_service.dart';
import 'package:geolocalizacionamd/app/errors/exceptions.dart';

class SaveDataServiceImp implements SaveDataService {
  @override
  Future<bool> onConnectDoctorAmd(
      final ConnectDoctorModel requestConnect, final String tokenUser) async {
    bool isConnect = false;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiConnectDoctorAmd =
        Uri.parse(ApiConstants.urlApiConnectDoctorAmd);
    final Map<String, String> headerConnect = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };
    final String bodyConnect = jsonEncode({
      'tokenDevice': requestConnect.tokenDevice,
      'latitude': requestConnect.latitude,
      'longitude': requestConnect.longitude,
      'idCity': requestConnect.cityId
    });

    try {
      responseApi = await http.post(urlApiConnectDoctorAmd,
          headers: headerConnect, body: bodyConnect);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        isConnect = true;
      } else {
        final String error =
            decodeRespApi[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
        throw ErrorAppException(message: error);
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return isConnect;
  }

  @override
  Future<bool> onDisconectDoctorAmd(final String tokenUser) async {
    bool isDisconnect = false;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiDisconectDoctorAmd =
        Uri.parse(ApiConstants.urlApiDisconectDoctorAmd);
    final Map<String, String> headerDisconect = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };

    try {
      responseApi =
          await http.post(urlApiDisconectDoctorAmd, headers: headerDisconect);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        isDisconnect = true;
      } else {
        final String error =
            decodeRespApi[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
        throw ErrorAppException(
            message:
                (error.isNotEmpty ? error : ApiConstants.generalErrorCodeApi));
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return isDisconnect;
  }

  @override
  Future<HomeServiceMap> onConfirmHomeService(
      final String tokenUser, final int idHomeService) async {
    late HomeServiceMap responseActiveAmdOrder;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiConfirmHomeService =
        Uri.parse(ApiConstants.urlApiConfirmHomeService);
    final Map<String, String> headerConfirm = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };
    final String bodyConfirm =
        jsonEncode({'idHomeServiceAttention': idHomeService});

    try {
      responseApi = await http.post(urlApiConfirmHomeService,
          headers: headerConfirm, body: bodyConfirm);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        responseActiveAmdOrder = HomeServiceMap.fromJson(decodeRespApi);
      } else {
        final String error =
            decodeRespApi[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
        throw ErrorAppException(
            message:
                (error.isNotEmpty ? error : ApiConstants.generalErrorCodeApi));
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return responseActiveAmdOrder;
  }

  @override
  Future<bool> onRejectHomeService(String tokenUser, int idHomeService) async {
    bool isReject = false;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiRejectHomeService =
        Uri.parse(ApiConstants.urlApiRejectHomeService);
    final Map<String, String> headerReject = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };
    final String bodyReject =
        jsonEncode({'idHomeServiceAttention': idHomeService});

    try {
      responseApi = await http.post(urlApiRejectHomeService,
          headers: headerReject, body: bodyReject);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        isReject = true;
      } else {
        final String error =
            decodeRespApi[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
        throw ErrorAppException(
            message:
                (error.isNotEmpty ? error : ApiConstants.generalErrorCodeApi));
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return isReject;
  }

  @override
  Future<bool> onCompleteHomeService(
      String tokenUser, int idHomeService) async {
    bool isComplete = false;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiCompleteHomeService =
        Uri.parse(ApiConstants.urlApiCompleteHomeService);
    final Map<String, String> headerComplete = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };
    final String bodyComplete =
        jsonEncode({'idHomeServiceAttention': idHomeService});

    try {
      responseApi = await http.post(urlApiCompleteHomeService,
          headers: headerComplete, body: bodyComplete);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        isComplete = true;
      } else {
        final String error =
            decodeRespApi[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
        throw ErrorAppException(
            message:
                (error.isNotEmpty ? error : ApiConstants.generalErrorCodeApi));
      }
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return isComplete;
  }
}
