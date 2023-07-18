import 'dart:convert';
import 'package:http/http.dart' as http;
import '/app/api/mappings/home_service_mapping.dart';
import '/app/errors/error_empty_data.dart';
import '/app/api/constants/api_constants.dart';
import '/app/api/mappings/photo_mapping.dart';
import '/app/errors/exceptions.dart';
import '/app/api/mappings/profile_mapping.dart';
import '/app/errors/error_amd_admin_finalized.dart';
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
      responseApi = await http.post(urlApiGetActiveAmdOrder,
          headers: headerActiveAmdOrder);
      decodeRespApi = json.decode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] ==
          ApiConstants.statusSuccessApi) {
        if (decodeRespApi[ApiConstants.dataLabelApi] != null) {
          responseActiveAmdOrder =
              HomeServiceMap.fromJson(decodeRespApi[ApiConstants.dataLabelApi]);
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

  @override
  Future<ProfileMap> getProfile(String tokenUser) async {
    ProfileMap profileMap;

    http.Response responseApi;

    Map<String, dynamic> decodeResApi;

    final Uri urlApiGetProfile = Uri.parse(ApiConstants.urlApiGetProfile);

    final Map<String, String> headerProfile = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };

    try {
      responseApi = await http.post(urlApiGetProfile, headers: headerProfile);

      decodeResApi = json.decode(responseApi.body);

      profileMap = ProfileMap.fromJson(decodeResApi);

      if (decodeResApi[ApiConstants.statusSuccessApi] ==
          ApiConstants.statusSuccessApi) {
        if (decodeResApi[ApiConstants.dataLabelApi] != null) {
          // responseGetProfile
        }
      }
    } on EmptyDataException {
      rethrow;
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return profileMap;
  }

  @override
  Future<void> validateIfOrderIsCompletedOrRejected(
      String tokenUser, int idHomeServiceAttention) async {
    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    final Uri urlValidateIfOrderIsCompletedOrRejected =
        Uri.parse(ApiConstants.urlApiValidateIfOrderIsCompletedOrRejected);
    final Map<String, String> header = {
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
      ApiConstants.headerToken: tokenUser
    };

    final String bodyValidateIfOrderIsCompletedOrRejected =
        jsonEncode({'idHomeServiceAttention': idHomeServiceAttention});

    try {
      responseApi = await http.post(urlValidateIfOrderIsCompletedOrRejected,
          headers: header, body: bodyValidateIfOrderIsCompletedOrRejected);
      decodeRespApi = jsonDecode(responseApi.body);

      if (decodeRespApi[ApiConstants.statusLabelApi] !=
          ApiConstants.statusSuccessApi) {
        final String error =
            decodeRespApi[ApiConstants.dataLabelApi][ApiConstants.codeLabelApi];
        
        if (error == ApiConstants.amdPendingAdminFinalizedCodeApi ||
            error == ApiConstants.amdconfirmedAdminFinalizedCodeApi) {
          throw AmdOrderAdminFinalizedException(message: error);
        } else {
          throw ErrorAppException(message: error);
        }
      }
    } on AmdOrderAdminFinalizedException {
      rethrow;
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }
  }


  @override
  Future<List<HomeServiceMap>> getHistoryAmdOrderList(String tokenUser, int idDoctorAmd)  async{

    http.Response responseApi;
    Map<String, dynamic> decodeRespApi;
    ///HomeServiceMap homeServiceMap;

    final Uri urlGetHistoryAmdOrder =
    Uri.parse(ApiConstants.urlApiGetHistoryAmdOrder);

    final Map<String, String> header = {
      ApiConstants.headerToken: tokenUser,
      ApiConstants.headerContentType: ApiConstants.headerValorContentType,
    };

    final String bodyGetHistoryAmdOrder =
    jsonEncode({'idDoctorAmd': idDoctorAmd});

    //List<HistoryAmdMap> historyAmdMapList;
    List<HomeServiceMap> homeServiceList;
    try {

      responseApi = await http.post(urlGetHistoryAmdOrder,
          headers: header, body: bodyGetHistoryAmdOrder);
       decodeRespApi = jsonDecode(responseApi.body);

       if(decodeRespApi[ApiConstants.statusLabelApi] ==
           ApiConstants.statusSuccessApi) {
        // historyAmdMapList = HistoryAmdMap.fromJson(decodeRespApi);

         homeServiceList = List<HomeServiceMap>.from(decodeRespApi[ApiConstants.dataLabelApi]
             .map((data) => HomeServiceMap.fromJson(data)));
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

    return homeServiceList;
  }
}
