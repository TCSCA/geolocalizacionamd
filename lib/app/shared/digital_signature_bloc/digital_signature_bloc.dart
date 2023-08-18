import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/controllers/image_profile_controller.dart';
import '../../errors/error_app_exception.dart';
import '../../pages/constants/app_constants.dart';

part 'digital_signature_event.dart';

part 'digital_signature_state.dart';

class DigitalSignatureBloc
    extends Bloc<DigitalSignatureEvent, DigitalSignatureState> {
  DigitalSignatureBloc() : super(DigitalSignatureInitial()) {
    Uint8List? doctorSignatureBuild;
    String doctorSignaturePath;

    on<DigitalSignatureEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SelectDoctorSignatureEvent>((event, emit) async {
      emit(LoadingDigitalSignatureState());

      try {
        doctorSignatureBuild = await ImageProfileController()
            .selectDigitalSignatureByGalleryCtrl();
        doctorSignaturePath =
            const Base64Encoder().convert(List.from(doctorSignatureBuild!));

        if(doctorSignatureBuild != null) {
        emit(DigitalSignatureSuccess(
        doctorSignatureBuild: doctorSignatureBuild,
        doctorSignaturePath: doctorSignaturePath));
        } else {
          throw ErrorAppException(message: 'Usted no tiene firma registrada');
        }

      } on ErrorAppException catch (exapp) {
        emit(DigitalSignatureErrorState(messageError: exapp.message));
      } on DigitalSignatureErrorState catch (exgen) {
        emit(DigitalSignatureErrorState(messageError: exgen.messageError));
      } catch (unknowerror) {
        emit(const DigitalSignatureErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<ConsultDigitalSignatureeEvent>((event, emit) async {
      try {
        emit(LoadingDigitalSignatureState());
        doctorSignatureBuild =
            await ImageProfileController().doConsultDigitalSignature();
        if(doctorSignatureBuild!.isNotEmpty) {
          doctorSignaturePath =
              const Base64Encoder().convert(List.from(doctorSignatureBuild!));
          emit(DigitalSignatureSuccess(
            doctorSignatureBuild: doctorSignatureBuild,
            doctorSignaturePath: doctorSignaturePath,
          ));
        } else {
          throw ErrorAppException(message: "No tiene una firma registrada");
        }


      } on ErrorAppException catch (exapp) {
        emit(DigitalSignatureErrorState(messageError: exapp.message));
      } on DigitalSignatureErrorState catch (exgen) {
        emit(DigitalSignatureErrorState(messageError: exgen.messageError));
      } catch (unknowerror) {
        emit(const DigitalSignatureErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });
  }
}
