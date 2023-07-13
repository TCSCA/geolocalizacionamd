import '/app/api/constants/api_constants.dart';
import '/app/api/mappings/register_date_mapping.dart';
import '/app/api/services/consult_data_service.dart';
import '/app/api/services/consult_data_service_implement.dart';
import '/app/api/services/lists_service.dart';
import '/app/api/services/lists_service_implement.dart';
import '/app/api/services/save_data_service.dart';
import '/app/api/services/save_data_service_implement.dart';
import '/app/core/models/connect_doctor_model.dart';
import '/app/core/models/home_service_model.dart';
import '/app/core/models/select_model.dart';
import '/app/errors/error_empty_data.dart';
import '/app/errors/exceptions.dart';
import 'secure_storage_controller.dart';
import '/app/core/models/reject_amd_model.dart';

class DoctorCareController {
  final SaveDataService saveDataService = SaveDataServiceImp();
  final SecureStorageController secureStorageController =
      SecureStorageController();
  final ConsultDataService consultDataService = ConsultDataServiceImp();
  final ListsService listsService = ListsServiceImp();

  Future<List<SelectModel>> getListStates(final String countryCode) async {
    List<SelectModel> listStates = [];
    late SelectModel opState;
    try {
      var opcionesStates = await listsService.getAllStates(countryCode);
      for (var opcion in opcionesStates) {
        opState = SelectModel(opcion.stateId.toString(), opcion.stateName);
        listStates.add(opState);
      }
      listStates.sort((a, b) => a.name.compareTo(b.name));
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return listStates;
  }

  Future<List<SelectModel>> getListCities(final String stateCode) async {
    List<SelectModel> listCities = [];
    late SelectModel opCity;
    try {
      var opcionesCities = await listsService.getAllCities(stateCode);
      for (var opcion in opcionesCities) {
        opCity = SelectModel(opcion.cityId.toString(), opcion.cityName);
        listCities.add(opCity);
      }
      listCities.sort((a, b) => a.name.compareTo(b.name));
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return listCities;
  }

  Future<bool> doConnectDoctorAmd(ConnectDoctorModel requestConnect) async {
    bool respApiConnect;

    try {
      var tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);
      var tokenFirebase = await secureStorageController
          .readSecureData(ApiConstants.tokenFirebaseLabel);

      requestConnect.tokenDevice = tokenFirebase;
      respApiConnect =
          await saveDataService.onConnectDoctorAmd(requestConnect, tokenUser);
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return respApiConnect;
  }

  Future<bool> doDisconectDoctorAmd() async {
    bool respApiDisconect;

    try {
      var tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);
      respApiDisconect = await saveDataService.onDisconectDoctorAmd(tokenUser);
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return respApiDisconect;
  }

  Future<HomeServiceModel> doConfirmHomeService(final int idHomeService) async {
    late HomeServiceModel responseHomeService;

    try {
      var tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);
      var responseService =
          await saveDataService.onConfirmHomeService(tokenUser, idHomeService);
      responseHomeService = HomeServiceModel(
          responseService.idHomeService,
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
          responseService.linkAmd);
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return responseHomeService;
  }

  Future<bool> doRejectHomeService(final RejectAmdModel requestReject) async {
    bool respApiReject;

    try {
      var tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);
      respApiReject =
          await saveDataService.onRejectHomeService(tokenUser, requestReject);
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return respApiReject;
  }

  Future<bool> doCompleteHomeService(final RejectAmdModel requestReject) async {
    bool respApiComplete;

    try {
      var tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);
      respApiComplete =
          await saveDataService.onCompleteHomeService(tokenUser, requestReject);
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return respApiComplete;
  }

  Future<HomeServiceModel> getHomeServiceAssigned() async {
    late HomeServiceModel responseHomeService;
    try {
      final tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);
      var responseService =
          await consultDataService.getActiveAmdOrder(tokenUser);
      responseHomeService = HomeServiceModel(
          responseService.idHomeService,
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
          responseService.linkAmd);
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

  Future<bool> validateDoctorInAttention() async {
    String inAttention = await secureStorageController
        .readSecureData(ApiConstants.doctorInAttentionLabel);
    bool newBoolValue = inAttention.toLowerCase() != "false";
    return newBoolValue;
  }

  Future<void> changeDoctorInAttention(final String inAttention) async {
    await secureStorageController.writeSecureData(
        ApiConstants.doctorInAttentionLabel, inAttention);
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

  Future<List<SelectModel>> getListgetReasonRejection() async {
    List<SelectModel> listReason = [];
    late SelectModel opReason;

    try {
      final tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);

      var opcionesReason = await listsService.getAllReasonRejection(tokenUser);
      for (var opcion in opcionesReason) {
        opReason = SelectModel(
            opcion.idReasonRejection.toString(), opcion.reasonForRejection);
        listReason.add(opReason);
      }
      listReason.sort((a, b) => a.name.compareTo(b.name));
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return listReason;
  }

  Future<void> validateIfOrderIsCompletedOrRejectedCtrl(
      int idHomeService) async {
    try {
      final tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);

      await consultDataService.validateIfOrderIsCompletedOrRejected(
          tokenUser, idHomeService);
    } on EmptyDataException {
      rethrow;
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }
  }
}
