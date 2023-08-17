import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/controllers/image_profile_controller.dart';

part 'digital_signature_event.dart';
part 'digital_signature_state.dart';

class DigitalSignatureBloc extends Bloc<DigitalSignatureEvent, DigitalSignatureState> {
  DigitalSignatureBloc() : super(DigitalSignatureInitial()) {

    Uint8List? doctorSignatureBuild;
    String doctorSignaturePath;

    on<DigitalSignatureEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SelectDoctorSignatureEvent>((event, emit) async {
      emit(LoadingDigitalSignatureState());

      doctorSignatureBuild =
      await ImageProfileController().selectDigitalSignatureByGalleryCtrl();
      doctorSignaturePath =
          const Base64Encoder().convert(List.from(doctorSignatureBuild!));

      emit(DigitalSignatureSuccess(
          doctorSignatureBuild: doctorSignatureBuild,
          doctorSignaturePath: doctorSignaturePath));
    });

    on<ConsultDigitalSignatureeEvent>((event, emit) async {

      emit(LoadingDigitalSignatureState());
      doctorSignatureBuild =
      await ImageProfileController().doConsultDigitalSignature();
      doctorSignaturePath =
          const Base64Encoder().convert(List.from(doctorSignatureBuild!));
      emit(DigitalSignatureSuccess(
          doctorSignatureBuild: doctorSignatureBuild,
          doctorSignaturePath: doctorSignaturePath,
        ));
    });
  }


}
