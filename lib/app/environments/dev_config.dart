import 'base_config.dart';

class DeveloperConfig implements BaseConfig {
  @override
  String get appName => "DEV Telemedicina24 AMD";
  @override
  String get apiHost => "https://desa.your24sevendoc.com/homeService/api";
  @override
  String get webSocketHost => "https://apides.your24sevendoc.com/ws";
  @override
  String get platform => "APP";
  @override
  String get headerPlatform => "platform";
  @override
  String get headerToken => "Token";
  @override
  String get headerContentType => "Content-Type";
  @override
  String get headerContentTypeValue => "application/json";
  @override
  String get headerApiKey => "ApiKeyGpsSHA";
  @override
  String get headerApiKeyValue => "ShA.GpS.123.";
}
