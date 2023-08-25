import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/controllers/doctor_care_controller.dart';

import '../../../../../core/models/file_amd_form_model.dart';

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
      } catch(err) {
      }

    });

    on<AmdViewFormEvent>((event, emit) async {

      try {
       fileAmdFormModel =  await DoctorCareController().viewFormAMD(event.idMedicalOrder);

        emit(AmdViewFormArchiveSuccessState(fileAmdFormModel: fileAmdFormModel!));
      }catch(err) {
      }
    });
  }
}
