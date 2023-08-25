import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/controllers/doctor_care_controller.dart';

part 'amd_form_event.dart';
part 'amd_form_state.dart';

class AmdFormBloc extends Bloc<AmdFormEvent, AmdFormState> {
  AmdFormBloc() : super(AmdFormInitial()) {
    on<AmdFormEvent>((event, emit) {
    });

    on<AmdRenewFormEvent>((event, state) {
      try {
        DoctorCareController().renewAmdForm(event.idMedicalOrder);
      } catch(err) {

      }

    });

    on<AmdViewFormEvent>((event, state) {

    });
  }
}
