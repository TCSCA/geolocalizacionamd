import '/app/api/constants/api_constants.dart';
import '/app/api/mappings/register_date_mapping.dart';
import '/app/api/services/consult_data_service.dart';
import '/app/api/services/consult_data_service_implement.dart';
import '/app/core/controllers/secure_storage_controller.dart';
import '/app/core/models/home_service_model.dart';
import '/app/errors/error_empty_data.dart';
import '/app/errors/exceptions.dart';

class ActiveAmdOrderCOntroller {
  final ConsultDataService consultDataService = ConsultDataServiceImp();
  final SecureStorageController secureStorageController =
      SecureStorageController();

  Future<HomeServiceModel> getHomeServiceAssigned() async {
    late HomeServiceModel responseHomeService;
    try {
      final tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);
      var responseService =
          await consultDataService.getActiveAmdOrder(tokenUser);
      responseHomeService = HomeServiceModel(
          responseService.idHomeService,
          responseService.idMedicalOrder,
          responseService.orderNumber,
          parseFecha(responseService.registerDate),
          responseService.fullNamePatient,
          responseService.documentType,
          responseService.identificationDocument,
          responseService.phoneNumberPatient,
          responseService.address,
          responseService.applicantDoctor,
          responseService.phoneNumberDoctor,
          responseService.typeService,
          //responseService.linkAmd,
          responseService.idStatusHomeService,
          responseService.statusHomeService,
          responseService.statusLinkAmd);
    } on EmptyDataException {
      rethrow;
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }
    return responseHomeService;
  }

  DateTime parseFecha(RegisterDate registerDate) {
    String years = '',
        months = '',
        days = '',
        hours = '',
        minutes = '',
        seconds = '';
    years = (registerDate.dateTime.date.year).toString();

    months = (registerDate.dateTime.date.month).toString();
    months = ((registerDate.dateTime.date.month) < 10 ? '0$months' : months);

    days = (registerDate.dateTime.date.day).toString();
    days = ((registerDate.dateTime.date.day) < 10 ? '0$days' : days);

    hours = (registerDate.dateTime.time.hour).toString();
    hours = ((registerDate.dateTime.time.hour) < 10 ? '0$hours' : hours);

    minutes = (registerDate.dateTime.time.minute).toString();
    minutes =
        ((registerDate.dateTime.time.minute) < 10 ? '0$minutes' : minutes);

    seconds = (registerDate.dateTime.time.second).toString();
    seconds =
        ((registerDate.dateTime.time.second) < 10 ? '0$seconds' : seconds);

    return DateTime.parse('$years-$months-$days $hours:$minutes:$seconds');
  }
}
