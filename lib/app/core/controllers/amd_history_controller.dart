import 'package:geolocalizacionamd/app/core/controllers/secure_storage_controller.dart';
import 'package:geolocalizacionamd/app/core/models/home_service_model.dart';

import '../../api/constants/api_constants.dart';
import '../../api/mappings/home_service_mapping.dart';
import '../../api/services/consult_data_service.dart';
import '../../api/services/consult_data_service_implement.dart';
import '../../errors/error_app_exception.dart';
import '../../errors/error_general_exception.dart';
import '../../errors/error_session_expired.dart';

class AmdHistoryController {
  final SecureStorageController secureStorageController =
      SecureStorageController();

  final ConsultDataService consultDataService = ConsultDataServiceImp();

  Future<List<HomeServiceModel>> getHistoryAmdOrderListCtrl() async {
    List<HomeServiceModel> homeServiceModelList = [];
    List<HomeServiceMap> homeServiceMap = [];
    HomeServiceModel homeServiceModel;

    try {
      final tokenUser =
          await secureStorageController.readSecureData(ApiConstants.tokenLabel);

      final idDocotorAmd = await secureStorageController
          .readSecureData(ApiConstants.idDoctorAmd);

      homeServiceMap = await consultDataService.getHistoryAmdOrderList(
          tokenUser, int.parse(idDocotorAmd));

      if (homeServiceMap != []) {
        for (var optionhistory in homeServiceMap) {
          final String day;
          final String month;
          final String hour;
          final String minute;
          final String second;

          day = optionhistory.registerDate.dateTime.date.day < 10
              ? '0${optionhistory.registerDate.dateTime.date.day}'
              : optionhistory.registerDate.dateTime.date.day.toString();
          month = optionhistory.registerDate.dateTime.date.month < 10
              ? '0${optionhistory.registerDate.dateTime.date.month}'
              : optionhistory.registerDate.dateTime.date.month.toString();

          hour = optionhistory.registerDate.dateTime.time.hour < 10 ?
          '0${optionhistory.registerDate.dateTime.time.hour}' :
          optionhistory.registerDate.dateTime.time.hour.toString();

          minute = optionhistory.registerDate.dateTime.time.minute < 10 ?
          '0${optionhistory.registerDate.dateTime.time.minute}' :
          optionhistory.registerDate.dateTime.time.minute.toString();

          second = optionhistory.registerDate.dateTime.time.second < 10 ?
          '0${optionhistory.registerDate.dateTime.time.second}' :
          optionhistory.registerDate.dateTime.time.second.toString();

          homeServiceModel = HomeServiceModel(
              optionhistory.idHomeService,
              optionhistory.idMedicalOrder,
              optionhistory.orderNumber,
              DateTime.parse(
                  '${optionhistory.registerDate.dateTime.date.year}-$month-$day $hour:$minute:$second'),
              optionhistory.fullNamePatient,
              optionhistory.documentType,
              optionhistory.identificationDocument,
              optionhistory.phoneNumberPatient,
              optionhistory.address,
              optionhistory.applicantDoctor,
              optionhistory.phoneNumberDoctor,
              optionhistory.typeService,
              /*(optionhistory.idStatusHomeService == 3
                  ? ''
                  : optionhistory.linkAmd),*/
              optionhistory.idStatusHomeService,
              optionhistory.statusHomeService,
              optionhistory.statusLinkAmd,
              optionhistory.statusOrder);

          homeServiceModelList.add(homeServiceModel);
        }
        homeServiceModelList
            .sort((a, b) => b.registerDate.compareTo(a.registerDate));

        /* homeServiceModel = List<HomeServiceModel>.from(
          homeServiceMap.map(
            (e) =>

                */ /* final String day;
          final String month;

          day = e.registerDate.dateTime.date.day < 10 ? '0${e.registerDate.dateTime.date.day}' : e.registerDate.dateTime.date.day.toString();
          month = e.registerDate.dateTime.date.month < 10 ? '0${e.registerDate.dateTime.date.month}' : e.registerDate.dateTime.date.month.toString();
         // '${e.registerDate.dateTime.date.year}-${e.registerDate.dateTime.date.month}-${e.registerDate.dateTime.date.day}'

         return*/ /*
                homeServiceModel.add(
              HomeServiceModel(
                e.idHomeService,
                e.orderNumber,
                DateTime.parse('1995-05-01'),
                e.fullNamePatient,
                e.documentType,
                e.identificationDocument,
                e.phoneNumberPatient,
                e.address,
                e.applicantDoctor,
                e.phoneNumberDoctor,
                e.typeService,
                e.linkAmd,
              ),
            ),
          ),
        );*/
      }
    } on ErrorAppException {
      rethrow;
    } on ErrorGeneralException {
      rethrow;
    } on SessionExpiredException {
      rethrow;
    } catch (unknowerror) {
      throw ErrorGeneralException();
    }

    return homeServiceModelList;
  }
}
