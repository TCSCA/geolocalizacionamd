import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/controllers/doctor_care_controller.dart';
import 'package:geolocalizacionamd/app/core/models/connect_doctor_model.dart';
import 'package:geolocalizacionamd/app/core/models/home_service_model.dart';
import 'package:geolocalizacionamd/app/core/models/select_model.dart';
import 'package:geolocalizacionamd/app/errors/error_empty_data.dart';
import 'package:geolocalizacionamd/app/errors/exceptions.dart';
import 'package:geolocalizacionamd/app/pages/constants/app_constants.dart';
import 'package:location/location.dart' as liblocation;
import '/app/shared/permissions/handle_location_permissions.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  bool doctorAvailableSwitch = false;
  final HandleLocationPermissions handleLocationPermissions =
      HandleLocationPermissions();
  liblocation.Location location = liblocation.Location();
  final DoctorCareController doctorCareController;
  MainBloc({required this.doctorCareController})
      : super(const MainInitial(doctorAvailable: false)) {
    on<ShowLocationDoctorStatesEvent>((event, emit) async {
      List<SelectModel> listAllStates = [];
      try {
        listAllStates =
            await doctorCareController.getListStates(event.countryCode);
        emit(LocationStatesSuccessState(listStates: listAllStates));
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

    on<ShowLocationDoctorCitiesEvent>((event, emit) async {
      List<SelectModel> listAllCities = [];
      try {
        listAllCities =
            await doctorCareController.getListCities(event.stateCode);
        emit(LocationCitiesSuccessState(
            listCities: listAllCities, selectedState: event.stateCode));
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

    on<ConnectDoctorAmdEvent>((event, emit) async {
      doctorAvailableSwitch = false;
      try {
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
            bool isConnect =
                await doctorCareController.doConnectDoctorAmd(requestConnect);

            if (isConnect) {
              doctorAvailableSwitch = true;
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
      doctorAvailableSwitch = true;
      try {
        bool isDisconect = await doctorCareController.doDisconectDoctorAmd();
        if (isDisconect) {
          doctorAvailableSwitch = false;
          emit(const DoctorServiceState(
              doctorAvailable: false,
              message: 'Ya no estarás disponible para atender'));
        } else {
          emit(const DoctorServiceErrorState(
              doctorAvailable: false,
              message: 'No se pudo desconectar su disponibilidad.'));
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
    on<CancelButtonAmdEvent>((event, emit) async {
      print('CancelButtonAmdEvent in ${(event.currentToggleSwitch)}');
      if (event.currentToggleSwitch == false) {
        print('CancelButtonAmdEvent out ${true}');
        emit(const CancelButtonAmdState(doctorAvailable: true));
      } else {
        print('CancelButtonAmdEvent out ${false}');
        emit(const CancelButtonAmdState(doctorAvailable: false));
      }
    });

    on<ShowHomeServiceAssignedEvent>((event, emit) async {
      bool doctorInAttention;
      try {
        //emit(const MainShowLoadingState());
        doctorInAttention =
            await doctorCareController.validateDoctorInAttention();

        if (doctorInAttention) {
          emit(const HomeServiceInAttentionState(
              message: AppConstants.codeDoctorInAttention));
        } else {
          var userHomeService =
              await doctorCareController.getHomeServiceAssigned();
          emit(HomeServiceSuccessState(homeServiceAssigned: userHomeService));
        }
      } on EmptyDataException catch (exapp) {
        emit(const HomeServiceEmptyState());
      } on ErrorAppException catch (exapp) {
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(HomeServiceErrorState(message: exgen.message));
      } catch (unknowerror) {
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ShowHomeServiceInAttentionEvent>((event, emit) async {
      bool doctorInAttention;
      try {
        //emit(const MainShowLoadingState());
        doctorInAttention =
            await doctorCareController.validateDoctorInAttention();

        if (doctorInAttention) {
          var userHomeService =
              await doctorCareController.getConfirmedHomeService();
          emit(ConfirmHomeServiceSuccessState(
              homeServiceConfirmed: userHomeService));
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
      try {
        //emit(const MainShowLoadingState());
        var userHomeService = await doctorCareController
            .doConfirmHomeService(event.idHomeService);
        await doctorCareController.changeDoctorInAttention('true');
        emit(ConfirmHomeServiceSuccessState(
            homeServiceConfirmed: userHomeService));
      } on ErrorAppException catch (exapp) {
        await doctorCareController.changeDoctorInAttention('false');
        emit(HomeServiceErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        await doctorCareController.changeDoctorInAttention('false');
        emit(HomeServiceErrorState(message: exgen.message));
      } catch (unknowerror) {
        await doctorCareController.changeDoctorInAttention('false');
        emit(const HomeServiceErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<DisallowAmdEvent>((event, emit) async {
      try {
        //emit(const MainShowLoadingState());
        var userHomeService =
            await doctorCareController.doRejectHomeService(event.idHomeService);
        await doctorCareController.changeDoctorInAttention('false');

        if (userHomeService) {
          emit(const DisallowHomeServiceSuccessState(message: 'MSGAPP-006'));
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

    on<CompleteAmdEvent>((event, emit) async {
      try {
        //emit(const MainShowLoadingState());
        var userHomeService = await doctorCareController
            .doCompleteHomeService(event.idHomeService);
        if (userHomeService) {
          await doctorCareController.changeDoctorInAttention('false');
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
  }
}
