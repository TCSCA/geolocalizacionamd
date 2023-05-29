
import 'package:geolocalizacionamd/app/api/mappings/amd_pending_mapping.dart';
import 'package:geolocalizacionamd/app/api/services/consult_data_service_implement.dart';
import 'package:geolocalizacionamd/app/core/models/amd_pending_model.dart';

import '../../api/services/consult_data_service.dart';
import '../../errors/error_active_connection.dart';
import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';

class AmdPendingController {

  final ConsultDataService consultDataService =  ConsultDataServiceImp();

 Future<AmdPendingModel?> doConsultDataAmdPending() async {
 late AmdPendingModel amdPendingModel;
 late AmdPendingMap? amdPendingMap;
     try{
      amdPendingMap =  await consultDataService.doGetAmdPending();

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
          serviceType: amdPendingMap.serviceType);

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