import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/controllers/change_password_controller.dart';
import '../../../core/models/change_password_model.dart';
import '../../../errors/error_app_exception.dart';
import '../../../errors/error_general_exception.dart';
import '../../constants/app_constants.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordModel? changePasswordModel;
  ChangePasswordController changePasswordController;

  ChangePasswordBloc({required this.changePasswordController})
      : super(ChangePasswordInitial()) {
    on<SendToServiceChangePassword>((event, emit) async {
      // TODO: implement event handler
      try {
        emit(ChangePasswordLoadingState());

        changePasswordModel = await changePasswordController.doChangePassword(
            event.username, event.password);

        if (changePasswordModel?.status == 'SUCCESS') {
          emit(ChangePasswordSuccessState(
              changePasswordModel: changePasswordModel!));
        } else if(changePasswordModel?.status == 'ERROR') {
          emit(ChangePasswordErrorState(
              messageError: changePasswordModel!.data!.message!
          ));
        }
      } on ErrorAppException catch (exapp) {
        emit(ChangePasswordErrorState(messageError: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(ChangePasswordErrorState(messageError: exgen.message));
      } catch (error) {
        emit(const ChangePasswordErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });
  }
}
