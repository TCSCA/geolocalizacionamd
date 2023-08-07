import '../../environments/environment.dart';

class ApiConstants {
  ApiConstants._();

  static final String headerToken = Environment().config.headerToken;
  static final String plataformaApp = Environment().config.platform;
  static final String headerPlataforma = Environment().config.headerPlatform;
  static final String headerContentType =
      Environment().config.headerContentType;
  static final String headerValorContentType =
      Environment().config.headerContentTypeValue;
  static final String headerApiKey = Environment().config.headerApiKey;
  static final String headerValorApiKey =
      Environment().config.headerApiKeyValue;
  static final String urlWebSocket = Environment().config.webSocketHost;
  static final String urlApi = Environment().config.apiHost;
  static final String urlApiLogin = '$urlApi/login';
  static final String urlApiResetLogin = '$urlApi/invalidateTokenByLogin';
  static final String urlApiLogout = '$urlApi/logout';
  static final String urlApiPhotos = '$urlApi/getPhotos';
  static final String urlApiConnectDoctorAmd = '$urlApi/connectDoctorAmd';
  static final String urlApiDisconectDoctorAmd = '$urlApi/disconectDoctorAmd';
  static final String urlApiGetActiveAmdOrder = '$urlApi/getActiveAmdOrder';
  static final String urlApiGetProfile= '$urlApi/profile';
  static final String urlApiValidateIfOrderIsCompletedOrRejected
  = '$urlApi/validateIfOrderIsCompletedOrRejected';
  static final String urlApiGetHistoryAmdOrder = '$urlApi/getHistoryAmdOrder';
  static final String urlApiGetAllGender = '$urlApi/getAllGender';
  static final String urlApiGetAllStatesByCountry =
      '$urlApi/getAllStatesByCountry/idCountry';
  static final String urlApiGetAllCityByState =
      '$urlApi/getAllCityByState/idState';
  static final String urlApiConfirmHomeService =
      '$urlApi/confirmHomeServiceAttention';
  static final String urlApiRejectHomeService =
      '$urlApi/rejectHomeServiceAttention';
  static final String urlApiCompleteHomeService =
      '$urlApi/completeHomeServiceAttention';
  static final String urlApiEditProfileService =
      '$urlApi/editProfile';
  static final String urlApiChangePassword = '$urlApi/changePassword';
  static final String urlApiGetAllReasonRejection =
      '$urlApi/getAllReasonRejectionAmd';
  static const String generalErrorCodeApi = 'MSG-001';
  static const String statusLabelApi = 'status';
  static const String statusSuccessApi = 'SUCCESS';
  static const String dataLabelApi = 'data';
  static const String codeLabelApi = 'code';
  static const String activeConnectionCodeApi = 'MSG-057';
  static const String tokenLabel = 'token';
  static const String idDoctorAmd = 'idDoctorAmd';
  static const String tokenFirebaseLabel = 'tokenFirebaseRegister';
  static const String doctorInAttentionLabel = 'doctorInAttention';
  static const String doctorConnectedLabel = 'doctorConnected';
  static const String amdPendingAdminFinalizedCodeApi = 'MSG-226';
  static const String amdconfirmedAdminFinalizedCodeApi = 'MSG-232';
}
