import 'base_config.dart';
import 'dev_config.dart';
import 'prod_config.dart';
import 'test_config.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String dev = 'DEV';
  static const String qa = 'QA';
  static const String prod = 'PROD';

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.prod:
        return ProductionConfig();
      case Environment.qa:
        return TestingConfig();
      default:
        return DeveloperConfig();
    }
  }
}
