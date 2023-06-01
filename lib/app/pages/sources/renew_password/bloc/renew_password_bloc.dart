import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/controllers/renew_password_controller.dart';
import '../../../../core/models/renew_password_model.dart';
import '../../../../errors/error_app_exception.dart';
import '../../../../errors/error_general_exception.dart';
import '../../../constants/app_constants.dart';

part 'renew_password_event.dart';

part 'renew_password_state.dart';

class RenewPasswordBloc extends Bloc<RenewPasswordEvent, RenewPasswordState> {
  RenewPasswordModel? renewPasswordModel;
  RenewPasswordController renewPasswordController;

  RenewPasswordBloc({required this.renewPasswordController})
      : super(RenewPasswordInitial()) {
    on<SendEmailToRenewPasswordEvent>((event, emit) async {
      try {
        emit(IsLoadingState());
        renewPasswordModel =
            await renewPasswordController.doRenewPassword(event.email);
        emit(SuccessRenewPassword(renewPasswordModel: renewPasswordModel!));
      } on ErrorAppException catch (exapp) {
        emit(ErrorRenewPasswordState(messageError: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(ErrorRenewPasswordState(messageError: exgen.message));
      } catch (error) {
        emit(const ErrorRenewPasswordState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });
  }
}
