import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/controllers/amd_pending_controller.dart';
import 'package:geolocalizacionamd/app/core/models/amd_pending_model.dart';

import '../../../../errors/error_app_exception.dart';
import '../../../../errors/error_general_exception.dart';
import '../../../constants/app_constants.dart';

part 'amd_pending_event.dart';

part 'amd_pending_state.dart';

class AmdPendingBloc extends Bloc<AmdPendingEvent, AmdPendingState> {
  AmdPendingModel? amdPendingResult;
  AmdPendingController amdPendingController;

  AmdPendingBloc({required this.amdPendingController})
      : super(AmdPendingInitial()) {
    on<ConsultDataAmdPendingEvent>((event, emit) async {
      try {
        emit(IsLoadingAmdPendingState());

        amdPendingResult = await amdPendingController.doConsultDataAmdPending();
        if (amdPendingResult == null) {

          emit(const IsNotAmdPendingState(message: 'No tiene Ningun AMD pendiente'));

        } else {

          emit(IsAmdPendingState(amdPendingModel: amdPendingResult!));
        }
      } on ErrorAppException catch (exapp) {

        emit(AmdPendingErrorState(message: exapp.message));

      } on ErrorGeneralException catch (exgen) {

        emit(AmdPendingErrorState(message: exgen.message));
      } catch (error) {

        emit(const AmdPendingErrorState(
            message: AppConstants.codeGeneralErrorMessage));
      }
    });
  }
}
