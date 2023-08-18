import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/models/profile_model.dart';

import '../../../../core/controllers/profile_controller.dart';
import '../../../../errors/error_app_exception.dart';
import '../../../../errors/error_general_exception.dart';
import '../../../../shared/image_build/bloc/image_profile_bloc.dart';
import '../../../constants/app_constants.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileController getProfileController;
  ProfileModel? profileModel;

  ProfileBloc({required this.getProfileController, this.profileModel})
      : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetProfileInitialEvent>((event, emit) {
      emit(ProfileInitial());
    });

    on<GetProfileEvent>((event, emit) async {
      emit(ProfileLoadingState());

      try {
        profileModel = await getProfileController.doGeProfileController();
        emit(ProfileSuccessState(profileModel: profileModel!));
      } on ErrorAppException catch (exapp) {
        emit(ProfileErrorState(messageError: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(ProfileErrorState(messageError: exgen.message));
      } catch (unknowerror) {
        emit(const ProfileErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });

    on<EditProfileEvent>((event, emit) async {
      emit(ProfileUpdateLoadingState());
      final bool updateProfileSuccess;

      ImageProfileBloc? imageProfileBloc = ImageProfileBloc();

      try {
    updateProfileSuccess =  await  getProfileController.doEditProfile(
          event.idAffiliate,
            event.fullName,
            event.email,
            event.dateOfBirth,
            event.idGender,
            event.phoneNumber,
            event.otherPhone,
            event.idCountry,
            event.idState,
            event.idCity,
            event.direction,
            event.mpps,
            event.cm,
            event.speciality,
            event.photoProfile,
            event.digitalSignature);

    if(updateProfileSuccess) {

      imageProfileBloc.add(ConsultPhotoEvent());

      emit(ProfileUpdateSuccessState());
    }

      } on ErrorAppException catch (exapp) {
        emit(ProfileErrorState(messageError: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(ProfileErrorState(messageError: exgen.message));
      } catch (unknowerror) {
        emit(const ProfileErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });
  }
}
