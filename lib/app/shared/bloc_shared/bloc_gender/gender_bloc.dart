import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../api/mappings/gender_mapping.dart';
import '../../../core/controllers/profile_controller.dart';
import '../../../errors/error_app_exception.dart';
import '../../../errors/error_general_exception.dart';
import '../../../errors/error_session_expired.dart';
import '../../../pages/constants/app_constants.dart';

part 'gender_event.dart';
part 'gender_state.dart';

class GenderBloc extends Bloc<GenderEvent, GenderState> {

  final ProfileController profileController;
  GenderMap? genderMap;
  GenderBloc({required this.profileController}) : super(GenderInitial()) {
    on<GenderEvent>((event, emit) {});

    on<ConsultAllGenderEvent>((event, emit) async {


try {
  genderMap = await profileController.doGetAllGender();
  emit(GenderDataSuccessState(genderMap: genderMap!));
} on ErrorAppException catch (exapp) {
  emit(GenderDataErrorState (messageError: exapp.message));
} on ErrorGeneralException catch (exgen) {
  emit(GenderDataErrorState(messageError: exgen.message));
} on SessionExpiredException catch (exgen ){
  emit(GenderDataErrorState(messageError: exgen.message));
} catch (unknowerror) {
  emit( const GenderDataErrorState(
      messageError: AppConstants.codeGeneralErrorMessage));
}

    });
  }
}
