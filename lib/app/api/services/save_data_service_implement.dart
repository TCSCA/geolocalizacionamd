import 'dart:convert';
import 'package:http/http.dart' as http;
import '/app/api/mappings/home_service_mapping.dart';
import '/app/core/models/connect_doctor_model.dart';
import '/app/api/constants/api_constants.dart';
import '/app/api/services/save_data_service.dart';
import '/app/errors/exceptions.dart';
import '/app/core/models/reject_amd_model.dart';

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
        responseActiveAmdOrder =
            HomeServiceMap.fromJson(decodeRespApi[ApiConstants.dataLabelApi]);
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
  Future<bool> onRejectHomeService(
      String tokenUser, RejectAmdModel requestReject) async {
    bool isReject = false;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiRejectHomeService =
        Uri.parse(ApiConstants.urlApiRejectHomeService);
    final Map<String, String> headerReject = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };
    final String bodyReject = jsonEncode({
      'idHomeServiceAttention': requestReject.idHomeServiceAttention,
      "comment": requestReject.comment,
      "idReasonReject": requestReject.idReasonReject
    });

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
      String tokenUser, RejectAmdModel requestReject) async {
    bool isComplete = false;
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlApiCompleteHomeService =
        Uri.parse(ApiConstants.urlApiCompleteHomeService);
    final Map<String, String> headerComplete = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };
    final String bodyComplete = jsonEncode({
      'idHomeServiceAttention': requestReject.idHomeServiceAttention,
      'idReasonReject': requestReject.idReasonReject
    });

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

  @override
  Future<bool> editProfileService(
      int idAffiliate,
      String fullName,
      String email,
      String dateOfBirth,
      int idGender,
      String phoneNumber,
      String? otherPhone,
      int idCountry,
      int idState,
      int idCity,
      String direction,
      int mpps,
      int cm,
      String speciality,
      String? photoProfile,
      String? digitalSignature,
      String tokenUser) async {
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    bool editProfileStatusSuccess = false;

    final Uri urlEditProfile = Uri.parse(ApiConstants.urlApiEditProfileService);

    final Map<String, String> headerEditProfile = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };

    final String bodyEditProfile = jsonEncode({
      "idAffiliate": idAffiliate,
      "fullName": fullName,
      "idGender": idGender,
      "birthday": dateOfBirth,
      "email": email,
      "phoneNumber": phoneNumber,
      "otherNumber": otherPhone,
      "idCity": idCity,
      "direction": direction,
      "speciality": speciality,
      "medicalLicense": "$mpps|$cm",
      "photoProfile": photoProfile,
      "digitalSignature": digitalSignature
    });

    try {
      responseApi = await http.post(urlEditProfile,
          headers: headerEditProfile, body: bodyEditProfile);

      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        editProfileStatusSuccess = true;
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

    return editProfileStatusSuccess;
  }
}
