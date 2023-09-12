import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '/app/core/controllers/doctor_care_controller.dart';
import '/app/core/controllers/menu_controller.dart';
import '/app/core/controllers/login_controller.dart';
import '/app/core/models/menu_model.dart';
import '/app/core/models/user_model.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/errors/error_active_connection.dart';
import '/app/errors/exceptions.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  List<MenuModel> listMenu = [];
  UserModel user = UserModel('', '', 0, []);
  final LoginController loginController;
  final MenuAppController menuController;
  final DoctorCareController doctorCareController = DoctorCareController();
  LoginBloc({required this.loginController, required this.menuController})
      : super(LoginInitial()) {
    on<ProcessLoginEvent>((event, emit) async {
      listMenu = [];
      try {
        emit(const LoginShowLoadingState());
        var userLogin =
            await loginController.doLoginUser(
            event.user.trim(), event.password.trim());
        final ByteData bytes =
            await rootBundle.load(AppConstants.profileDefaultImage);
        userLogin.photoPerfil = bytes.buffer.asUint8List();
        listMenu = await menuController.getListMenu(event.languageCode);
        user = userLogin;
        emit(LoginSuccessState(user: userLogin, listMenu: listMenu));
      } on ErrorAppException catch (exapp) {
        emit(LoginErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(LoginErrorState(message: exgen.message));
      } on ActiveConnectionException catch (exac) {
        emit(LoginActiveState(message: exac.message));
      } catch (unknowerror) {
        emit(const LoginErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ProcessLogoutEvent>((event, emit) async {
      try {
        emit(const LoginShowLoadingState());
        var connectedDoctor = await loginController.validateConnectedDoctor();
        if (connectedDoctor) {
          emit(const LogoutDoctorConnectedState(message: 'MSG-234'));
        } else {
          var doctorInAttention =
              await doctorCareController.validateDoctorInAttention();
          if (doctorInAttention) {
            emit(const LogoutDoctorInAttentionState(message: 'MSGAPP-009'));
          } else {
            await loginController.doLogoutUser();
            emit(const LogoutSuccessState());
          }
        }
      } on ErrorAppException catch (exapp) {
        emit(LoginErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(LoginErrorState(message: exgen.message));
      } on SessionExpiredException catch (exesi) {
        emit(LogoutInvalidSessionState(message: exesi.message));
      } catch (unknowerror) {
        emit(const LoginErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ProcessResetLoginEvent>((event, emit) async {
      listMenu = [];
      try {
        emit(const LoginShowLoadingState());
        var userLogin =
            await loginController.doResetLoginUser(
            event.user.trim(), event.password.trim());
        final ByteData bytes =
            await rootBundle.load(AppConstants.profileDefaultImage);
        userLogin.photoPerfil = bytes.buffer.asUint8List();
        listMenu = await menuController.getListMenu(event.languageCode);
        user = userLogin;
        emit(LoginSuccessState(user: userLogin, listMenu: listMenu));
      } on ErrorAppException catch (exapp) {
        emit(LoginErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(LoginErrorState(message: exgen.message));
      } catch (error) {
        emit(const LoginErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });

/*Solo para pruebas y mostrar el key desde en login, se debe quitar luego*/
    on<ShowFirebaseKeyEvent>((event, emit) async {
      try {
        emit(const LoginShowLoadingState());
        var valorKey = await loginController.getFirebaseKey();
        emit(ShowFirebaseKeyState(firebaseKey: valorKey));
      } on ErrorAppException catch (exapp) {
        emit(LoginErrorState(message: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(LoginErrorState(message: exgen.message));
      } catch (unknowerror) {
        emit(const LoginErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });
  }
}
