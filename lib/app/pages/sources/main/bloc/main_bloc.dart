import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/errors/error_amd_admin_finalized.dart';
import 'package:location/location.dart' as liblocation;
import '/app/core/controllers/doctor_care_controller.dart';
import '/app/core/models/connect_doctor_model.dart';
import '/app/core/models/home_service_model.dart';
import '/app/core/models/select_model.dart';
import '/app/errors/error_empty_data.dart';
import '/app/errors/exceptions.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/shared/permissions/handle_location_permissions.dart';
import '/app/core/models/reject_amd_model.dart';
part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  bool doctorAvailableSwitch = false;
  late HomeServiceModel homeServiceConfirmed, homeServicePending;
  final HandleLocationPermissions handleLocationPermissions =
      HandleLocationPermissions();
  liblocation.Location location = liblocation.Location();
  final DoctorCareController doctorCareController;
  MainBloc({required this.doctorCareController}) : super(const MainInitial()) {
    on<ShowLocationDoctorStatesEvent>((event, emit) async {
      List<SelectModel> listAllStates = [];
      try {
        emit(
            const LocationShowLoadingState(message: 'Procesando su solicitud'));
        listAllStates =
            await doctorCareController.getListStates(event.countryCode);
        emit(LocationStatesSuccessState(listStates: listAllStates));
      } on ErrorAppException catch (exapp) {
        emit(LocationErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(LocationErrorState(message: exgen.message));
      } catch (unknowerror) {
        emit(const LocationErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ShowLocationDoctorCitiesEvent>((event, emit) async {
      List<SelectModel> listAllCities = [];
      try {
        emit(
            const LocationShowLoadingState(message: 'Procesando su solicitud'));
        listAllCities =
            await doctorCareController.getListCities(event.stateCode);
        emit(LocationCitiesSuccessState(
            listCities: listAllCities, selectedState: event.stateCode));
      } on ErrorAppException catch (exapp) {
        emit(LocationErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(LocationErrorState(message: exgen.message));
      } catch (unknowerror) {
        emit(const LocationErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ConnectDoctorAmdEvent>((event, emit) async {
      //doctorAvailableSwitch = false;
      try {
        emit(const DisableButtonState());
        bool isService = await handleLocationPermissions.checkLocationService();
        if (isService) {
          bool isPermission =
              await handleLocationPermissions.checkLocationPermission();
          if (isPermission) {
            final locationData = await location.getLocation();
            final latitudeUser = locationData.latitude;
            final longitudeUser = locationData.longitude;

            var requestConnect = ConnectDoctorModel(
                tokenDevice: '',
                latitude: latitudeUser!,
                longitude: longitudeUser!,
                cityId: int.parse(event.locationCity));

            emit(const LocationShowLoadingState(
                message: 'Activando su servicio'));
            bool isConnect =
                await doctorCareController.doConnectDoctorAmd(requestConnect);

            if (isConnect) {
              doctorAvailableSwitch = true;
              await doctorCareController.changeDoctorConnected('true');
              emit(const DoctorServiceState(
                  doctorAvailable: true, message: 'MSGAPP-001'));
            } else {
              emit(const DoctorServiceErrorState(
                  doctorAvailable: false,
                  message: 'No se pudo conectar su disponibilidad.'));
            }
          } else {
            emit(const DoctorServiceErrorState(
                doctorAvailable: false, message: 'MSGAPP-002'));
          }
        } else {
          emit(const DoctorServiceErrorState(
              doctorAvailable: false, message: 'MSGAPP-003'));
        }
      } on ErrorAppException catch (exapp) {
        emit(DoctorServiceErrorState(
            doctorAvailable: false, message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(DoctorServiceErrorState(
            doctorAvailable: false, message: exgen.message));
      } catch (unknowerror) {
        emit(const DoctorServiceErrorState(
            doctorAvailable: false,
            message: AppConstants.codeGeneralErrorMessage));
      }
    });
    on<DisconectDoctorAmdEvent>((event, emit) async {
      //doctorAvailableSwitch = true;
      try {
        emit(const MainShowLoadingState(message: 'Desactivando su servicio'));
        bool isDisconect = await doctorCareController.doDisconectDoctorAmd();
        if (isDisconect) {
          doctorAvailableSwitch = false;
          await doctorCareController.changeDoctorConnected('false');
          emit(const DoctorServiceState(
              doctorAvailable: false,
              message: 'Ya no estarás disponible para atender'));
        } else {
          emit(const DoctorServiceErrorState(
              doctorAvailable: true,
              message: 'No se pudo desconectar su disponibilidad.'));
        }
      } on ErrorAppException catch (exapp) {
        emit(DoctorServiceErrorState(
            doctorAvailable: true, message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(DoctorServiceErrorState(
            doctorAvailable: true, message: exgen.message));
      } catch (unknowerror) {
        emit(const DoctorServiceErrorState(
            doctorAvailable: true,
            message: AppConstants.codeGeneralErrorMessage));
      }
    });
    on<CancelButtonAmdEvent>((event, emit) async {
      if (kDebugMode) {
        print('CancelButtonAmdEvent in ${(event.currentToggleSwitch)}');
      }
      if (event.currentToggleSwitch == false) {
        if (kDebugMode) {
          print('CancelButtonAmdEvent out ${true}');
        }
        emit(const CancelButtonAmdState(doctorAvailable: true));
      } else {
        if (kDebugMode) {
          print('CancelButtonAmdEvent out ${false}');
        }
        emit(const CancelButtonAmdState(doctorAvailable: false));
      }
    });

    on<ShowHomeServiceAssignedEvent>((event, emit) async {
      bool doctorInAttention;
      try {
        emit(const ShowLoadingAmdAssignedState(
            message: 'Consultando Atenciones Pendientes'));
        doctorInAttention =
            await doctorCareController.validateDoctorInAttention();

        if (doctorInAttention) {
          emit(const HomeServiceInAttentionState(
              message: AppConstants.codeDoctorInAttention));
        } else {
          var userHomeService =
              await doctorCareController.getHomeServiceAssigned();
          if (userHomeService.idStatusHomeService ==
              AppConstants.idHomeServiceConfirmed) {
            await doctorCareController.changeDoctorInAttention('true');
            try {
              //Desconectar para que no reciba otra atencion.
              await doctorCareController.doDisconectDoctorAmd();
              //Cambiar el estatus de la disponibilidad del doctor.
              await doctorCareController.changeDoctorConnected('false');
            } catch (e) {/*Nada que hacer si falla*/}
            doctorAvailableSwitch = false;
            //Almecenar AMD para mostrar en atencion
            homeServiceConfirmed = userHomeService;
            await doctorCareController.changeIdAmdConfirmed(
                homeServiceConfirmed.idHomeService.toString());
            emit(const HomeServicePendingFinishState(message: "MSGAPP-011"));
          } else {
            //Web desconecta al doctor cuando asigna AMD.
            //Cambiar el estatus de la disponibilidad del doctor en App.
            doctorAvailableSwitch = false;
            await doctorCareController.changeDoctorConnected('false');
            //Cambiar el estatus de AMD pendiente para el doctor.
            await doctorCareController.changeDoctorAmdPending('true');
            homeServicePending = userHomeService;
            emit(HomeServiceSuccessState(homeServiceAssigned: userHomeService));
          }
        }
      } on EmptyDataException {
        final String statusConnected =
            await doctorCareController.verifyConnected();
        statusConnected == 'Doctor disponible para atencion'
            ? doctorAvailableSwitch = true
            : doctorAvailableSwitch = false;
        emit(HomeServiceEmptyState(doctorAvailable: doctorAvailableSwitch));
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceAssignedErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceAssignedErrorState(message: exgen.message));
      } catch (unknowerror) {
        emit(const HomeServiceAssignedErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ShowHomeServiceInAttentionEvent>((event, emit) async {
      bool doctorInAttention;
      try {
        /* emit(const ShowLoadingInAttentionState(
            message: 'Procesando su solicitudd')); */
        doctorInAttention =
            await doctorCareController.validateDoctorInAttention();
        //await Future.delayed(const Duration(seconds: 2));
        if (doctorInAttention) {
          emit(ShowHomeServiceInAttentionState(
              homeServiceConfirmed: homeServiceConfirmed));
        } else {
          emit(const HomeServiceInAttentionState(
              message: AppConstants.codeDoctorInAttention));
        }
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceErrorState(message: exgen.message));
      } catch (unknowerror) {
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ConfirmAmdEvent>((event, emit) async {
      late HomeServiceModel userHomeService;
      try {
        emit(const MainShowLoadingState(message: 'Confirmando la orden'));
        await doctorCareController
            .validateIfOrderIsCompletedOrRejectedCtrl(event.idHomeService);
        userHomeService = await doctorCareController
            .doConfirmHomeService(event.idHomeService);
        await doctorCareController.changeDoctorInAttention('true');
        //Cambiar el estatus de AMD pendiente para el doctor.
        await doctorCareController.changeDoctorAmdPending('false');
        try {
          //Desconectar para que no reciba otra atencion.
          await doctorCareController.doDisconectDoctorAmd();
          //Cambiar el estatus de la disponibilidad del doctor.
          await doctorCareController.changeDoctorConnected('false');
        } catch (e) {/*Nada que hacer si falla*/}
        doctorAvailableSwitch = false;
        //Almecenar AMD para mostrar en atencion
        homeServiceConfirmed = userHomeService;
        await doctorCareController.changeIdAmdConfirmed(
            homeServiceConfirmed.idHomeService.toString());
        emit(ConfirmHomeServiceSuccessState(
            homeServiceConfirmed: userHomeService));
      } on ErrorAppException catch (exapp) {
        await doctorCareController.changeDoctorInAttention('false');
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        await doctorCareController.changeDoctorInAttention('false');
        emit(HomeServiceErrorState(message: exgen.message));
      } on AmdOrderAdminFinalizedException catch (exadmin) {
        await doctorCareController.changeIdAmdConfirmed('0');
        await doctorCareController.changeDoctorAmdPending('false');
        await doctorCareController.changeDoctorInAttention('false');
        try {
          await doctorCareController.doDisconectDoctorAmd();
        } catch (e) {/*Nada que hacer si falla*/}
        doctorAvailableSwitch = false;
        emit(ShowAmdOrderAdminFinalizedState(message: exadmin.message));
      } catch (unknowerror) {
        await doctorCareController.changeDoctorInAttention('false');
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<DisallowAmdEvent>((event, emit) async {
      try {
        emit(const MainShowLoadingState(message: 'Rechazando la orden'));

        var requestReject = RejectAmdModel(
            idHomeServiceAttention: event.idHomeService,
            comment: '',
            idReasonReject: int.parse(event.idReason));

        var userHomeService =
            await doctorCareController.doRejectHomeService(requestReject);

        if (userHomeService) {
          await doctorCareController.changeDoctorInAttention('false');
          //Cambiar el estatus de AMD pendiente para el doctor.
          await doctorCareController.changeDoctorAmdPending('false');
          doctorAvailableSwitch = false;
          emit(
            const DisallowHomeServiceSuccessState(message: 'MSGAPP-006'),
          );
        } else {
          emit(
            const HomeServiceErrorState(message: 'MSGAPP-005'),
          );
        }
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceErrorState(message: exgen.message));
      } catch (unknowerror) {
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<CompleteAmdEvent>((event, emit) async {
      try {
        emit(
            const ShowLoadingInAttentionState(message: 'Finalizando la orden'));
        var requestReject = RejectAmdModel(
            idHomeServiceAttention: event.idHomeService,
            idReasonReject: int.parse(event.idReason),
            comment: '');
        var userHomeService =
            await doctorCareController.doCompleteHomeService(requestReject);
        if (userHomeService) {
          //doctorAvailableSwitch = false;
          await doctorCareController.changeDoctorInAttention('false');
          doctorAvailableSwitch = false;
          emit(const CompleteHomeServiceSuccessState(message: 'MSGAPP-007'));
        } else {
          emit(const HomeServiceErrorState(message: 'MSGAPP-005'));
        }
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceErrorState(message: exgen.message));
      } catch (unknowerror) {
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ChangeLocationDoctorCityEvent>((event, emit) async {
      //emit(const LoginShowLoadingState());
      emit(ChangeLocationDoctorCityState(selectedCity: event.cityCode));
    });

    on<ShowReasonRejectionStatesEvent>((event, emit) async {
      List<SelectModel> listAllReason = [];
      try {
        emit(const MainShowLoadingState(message: 'Procesando solicitud'));

        await doctorCareController.validateIfOrderIsCompletedOrRejectedCtrl(
            event.homeServiceAssigned.idHomeService);

        listAllReason = await doctorCareController.getListgetReasonRejection();
        emit(ReasonRejectionSuccessState(
            homeServiceAssigned: event.homeServiceAssigned,
            listReasonRejection: listAllReason));
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceErrorState(message: exgen.message));
      } on AmdOrderAdminFinalizedException catch (exadmin) {
        await doctorCareController.changeDoctorInAttention('false');
        doctorAvailableSwitch = false;
        emit(ShowAmdOrderAdminFinalizedState(message: exadmin.message));
      } catch (unknowerror) {
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ShowReasonCompleteStatesEvent>((event, emit) async {
      List<SelectModel> listAllReason = [];
      try {
        emit(
            const ShowLoadingInAttentionState(message: 'Procesando solicitud'));
        listAllReason = await doctorCareController.getListgetReasonRejection();
        emit(ReasonCompleteSuccessState(
            homeServiceAssigned: event.homeServiceAssigned,
            listReasonComplete: listAllReason));
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceErrorState(message: exgen.message));
      } catch (unknowerror) {
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ValidateOrderAmdProcessedAdminEvent>((event, emit) async {
      try {
        emit(
            const ShowLoadingInAttentionState(message: 'Procesando solicitud'));
        await doctorCareController.validateIfOrderIsCompletedOrRejectedCtrl(
            event.homeServiceAssigned.idHomeService);
        emit(AmdOrderAdminSuccessState(
            homeServiceAssigned: event.homeServiceAssigned));
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceErrorState(message: exgen.message));
      } on AmdOrderAdminFinalizedException catch (exadmin) {
        await doctorCareController.changeIdAmdConfirmed('0');
        await doctorCareController.changeDoctorAmdPending('false');
        await doctorCareController.changeDoctorInAttention('false');
        doctorAvailableSwitch = false;
        emit(ShowAmdOrderAdminFinalizedState(message: exadmin.message));
      } catch (unknowerror) {
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ValidateDoctorAmdAssignedEvent>((event, emit) async {
      bool doctorAmdAssigned, doctorInAttention;
      try {

        var idAmdConfirmed = await doctorCareController.getAmdConfirmed();
        if (idAmdConfirmed != '0') {
          await doctorCareController.validateIfOrderIsCompletedOrRejectedCtrl(
              int.parse(idAmdConfirmed));
        }

        doctorAmdAssigned =
            await doctorCareController.validateDoctorAmdAssigned();
        if (doctorAmdAssigned) {
          emit(const DoctorHomeServiceAssignedState(message: 'MSG-230'));
        } else {
          doctorInAttention =
              await doctorCareController.validateDoctorInAttention();
          if (doctorInAttention) {
            emit(const DoctorHomeServiceAttentionState(message: 'MSGAPP-012'));
          } else {
            emit(const NotHomeServiceAssignedState());
          }
        }
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceErrorState(message: exgen.message));
      } on AmdOrderAdminFinalizedException {
        await doctorCareController.changeIdAmdConfirmed('0');
        await doctorCareController.changeDoctorAmdPending('false');
        emit(const NotHomeServiceAssignedState());
      } catch (unknowerror) {
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ValidateConfirmedAmdProcessedAdminEvent>((event, emit) async {
      try {
        emit(const MainShowLoadingState(message: 'Procesando solicitud'));
        var idAmdConfirmed = await doctorCareController.getAmdConfirmed();
        if (idAmdConfirmed != '0') {
          await doctorCareController.validateIfOrderIsCompletedOrRejectedCtrl(
              int.parse(idAmdConfirmed));
        }
        emit(const AmdConfirmedAdminSuccessState());
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceErrorState(message: exgen.message));
      } on AmdOrderAdminFinalizedException catch (exadmin) {
        await doctorCareController.changeIdAmdConfirmed('0');
        await doctorCareController.changeDoctorInAttention('false');
        await doctorCareController.changeDoctorAmdPending('false');
        doctorAvailableSwitch = false;
        emit(ShowAmdOrderAdminFinalizedState(message: exadmin.message));
      } catch (unknowerror) {
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    /* on<CheckDoctorConnectedEvent>((event, emit) async {
      try {
        //emit(const MainShowLoadingState(message: 'Procesando solicitud'));
      final String statusConnected =
          await doctorCareController.verifyConnected();
      statusConnected == 'Doctor disponible para atencion'
          ? doctorAvailableSwitch = true
          : doctorAvailableSwitch = false;
        //emit(DoctorConnectedState(doctorAvailable: doctorAvailableSwitch));
        // ignore: unused_catch_clause
      } on ErrorAppException catch (exapp) {
        doctorAvailableSwitch = false;
        // ignore: unused_catch_clause
      } on ErrorGeneralException catch (exgen) {
        doctorAvailableSwitch = false;
      } catch (unknowerror) {
        doctorAvailableSwitch = false;
      }
    }); */
  }
}
