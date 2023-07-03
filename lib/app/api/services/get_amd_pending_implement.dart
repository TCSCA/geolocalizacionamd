import 'dart:convert';
import 'package:flutter/services.dart';
import '/app/errors/error_app_exception.dart';
import '/app/errors/error_general_exception.dart';
import '/app/api/mappings/amd_pending_mapping.dart';
import 'get_amd_pending.dart';

class ConsultDataServiceImp implements GetAmdPendingService {

  @override
  Future<AmdPendingMap?> doGetAmdPending() async {
    Map<String, dynamic> decodeResp;
    AmdPendingMap opciones;

    try {
      final resp = await rootBundle.loadString('assets/data/amd_pending.json');
      decodeResp = json.decode(resp);

      opciones = AmdPendingMap.fromJson(decodeResp);
    } on ErrorAppException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return opciones;
  }

}