import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';
import '/app/errors/error_session_expired.dart';
import '/app/errors/error_general_exception.dart';

class HttpErrorInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    // Registra la respuesta
    if (kDebugMode) {
      print('Recibida respuesta de: ${data.url}');
      print('Código de estado: ${data.statusCode}');
      print('Cuerpo: ${data.body}');
    }

    if (data.statusCode == 401) {
      //Unauthorized
      throw SessionExpiredException(message: 'MSGHTTP-401');
    }

    if (data.statusCode == 403) {
      //Forbidden
      throw SessionExpiredException(message: 'MSGHTTP-403');
    }

    if (data.statusCode == 500 || data.statusCode == 503) {
      //Server Error
      throw ErrorGeneralException();
    }

    return data;
  }
}
