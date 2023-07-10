import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/models/profile_model.dart';

import '../../../../core/controllers/profile_controller.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final ProfileController getProfileController;
   ProfileModel? profileModel;

  ProfileBloc({required this.getProfileController, this.profileModel}) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetProfileEvent>((event, emit) async {
      profileModel = await getProfileController.doGeProfileController();

      emit(ProfileSuccessState(profileModel: profileModel!));
    });
  }
}
