import 'base_config.dart';

class DeveloperConfig implements BaseConfig {
  @override
  String get appName => "DEV Telemedicina24";
  @override
  String get apiHost => "https://apides.your24sevendoc.com/api";
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
  String get headerBiscom => "BISCOMM_KEY";
  @override
  String get headerBiscomValue => "abcd123456";
}
