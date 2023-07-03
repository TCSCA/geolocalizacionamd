import '/app/api/mappings/amd_pending_mapping.dart';
import '/app/api/services/get_amd_pending_implement.dart';
import '/app/core/models/amd_pending_model.dart';
import '/app/api/services/get_amd_pending.dart';
import '/app/errors/error_active_connection.dart';
import '/app/errors/error_app_exception.dart';
import '/app/errors/error_general_exception.dart';

class AmdPendingController {
  final GetAmdPendingService consultDataService = ConsultDataServiceImp();

  Future<AmdPendingModel?> doConsultDataAmdPending() async {
    late AmdPendingModel amdPendingModel;
    late AmdPendingMap? amdPendingMap;
    try {
      amdPendingMap = await consultDataService.doGetAmdPending();

      amdPendingModel = AmdPendingModel(
        orderTime: amdPendingMap!.orderTime,
        orderId: amdPendingMap.orderId,
        patientName: amdPendingMap.patientName,
        idDocumentationPatient: amdPendingMap.idDocumentationPatient,
        phonePatient: amdPendingMap.phonePatient,
        state: amdPendingMap.state,
        city: amdPendingMap.city,
        direction: amdPendingMap.direction,
        doctorName: amdPendingMap.doctorName,
        phoneDoctor: amdPendingMap.phoneDoctor,
        serviceType: amdPendingMap.serviceType,
      );
    } on ErrorAppException {
      rethrow;
    } on ActiveConnectionException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return amdPendingModel;
  }
}
