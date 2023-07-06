import '/app/pages/constants/app_constants.dart';
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

  late BaseConfig config;

  initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case AppConstants.environmentProduction:
        return ProductionConfig();
      case AppConstants.environmentTesting:
        return TestingConfig();
      default:
        return DeveloperConfig();
    }
  }
}
