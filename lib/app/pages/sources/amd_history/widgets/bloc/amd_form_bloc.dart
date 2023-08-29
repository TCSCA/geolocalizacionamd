import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/controllers/doctor_care_controller.dart';

import '../../../../../core/models/file_amd_form_model.dart';
import '../../../../../errors/error_app_exception.dart';
import '../../../../../errors/error_general_exception.dart';
import '../../../../constants/app_constants.dart';

part 'amd_form_event.dart';
part 'amd_form_state.dart';

class AmdFormBloc extends Bloc<AmdFormEvent, AmdFormState> {
  AmdFormBloc() : super(AmdFormInitial()) {
    on<AmdFormEvent>((event, emit) {
    });

    FileAmdFormModel? fileAmdFormModel;

    on<AmdRenewFormEvent>((event, emit) async {
      String urlFormRenew;
      emit(AmdFormLoading());
      try {
        urlFormRenew = await DoctorCareController().renewAmdForm(event.idMedicalOrder);

        emit(AmdRenewFormSuccessState(urlFormRenew: urlFormRenew));
      } on ErrorAppException catch (exapp) {
        emit(AmdRenewFormErrorState(messageError: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(AmdRenewFormErrorState(messageError: exgen.message));
      } catch (error) {
        emit(const AmdRenewFormErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }

    });

    on<AmdViewFormEvent>((event, emit) async {
      emit(AmdFormLoading());
      try {
       fileAmdFormModel =  await DoctorCareController().viewFormAMD(event.idMedicalOrder);

        emit(AmdViewFormArchiveSuccessState(fileAmdFormModel: fileAmdFormModel!));
      } on ErrorAppException catch (exapp) {
        emit(AmdViewFormArchiveErrorState(messageError: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(AmdViewFormArchiveErrorState(messageError: exgen.message));
      } catch (error) {
        emit(const AmdViewFormArchiveErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });
  }
}
