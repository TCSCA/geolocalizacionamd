import '/app/api/constants/api_constants.dart';

class ErrorGeneralException implements Exception {
  final String message;

  ErrorGeneralException({this.message = ApiConstants.generalErrorCodeApi});
}
