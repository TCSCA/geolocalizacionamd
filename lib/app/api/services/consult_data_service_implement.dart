import 'dart:convert';

import 'package:flutter/services.dart';

import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';
import '../mappings/amd_pending_mapping.dart';
import 'consult_data_service.dart';

class ConsultDataServiceImp implements ConsultDataService {

  Future<AmdPendingMap?> doGetAmdPending() async {
    const headerLogger = 'ListsService.getMenu';
    Map<String, dynamic> decodeResp;
    AmdPendingMap opciones;

    try {
      final resp = await rootBundle.loadString('assets/data/amd_pending.json');
      decodeResp = json.decode(resp);

      opciones = AmdPendingMap.fromJson(decodeResp);
    } on ErrorAppException catch (errorapp) {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return opciones;
  }

}