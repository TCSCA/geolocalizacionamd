import 'base_config.dart';

class ProductionConfig implements BaseConfig {
  @override
  String get appName => "Telemedicina24 AMD";
  @override
  String get apiHost => "";
  @override
  String get webSocketHost => "";
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
