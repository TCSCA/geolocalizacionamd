import '../../environments/environment.dart';

class ApiConstants {
  ApiConstants._();

  static final String plataformaApp = Environment().config.platform;
  static final String headerPlataforma = Environment().config.headerPlatform;
  static final String headerContentType =
      Environment().config.headerContentType;
  static final String headerValorContentType =
      Environment().config.headerContentTypeValue;
  static final String headerBiscom = Environment().config.headerBiscom;
  static final String headerValorBiscom =
      Environment().config.headerBiscomValue;
  static final String urlWebSocket = Environment().config.webSocketHost;
  static final String urlApi = Environment().config.apiHost;
  static final String urlApiLogin = '$urlApi/login';
  static final String urlApiResetLogin = '$urlApi/newSession';
  static const String generalErrorCodeApi = 'MSG-001';
  static const String statusLabelApi = 'status';
  static const String statusSuccessApi = 'SUCCESS';
  static const String dataLabelApi = 'data';
  static const String activeConnectionCodeApi = 'MSG-057';
  static const String tokenLabel = 'token';
}
