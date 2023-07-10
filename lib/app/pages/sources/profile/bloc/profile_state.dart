part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileSuccessState extends ProfileState {

  ProfileModel profileModel;

  ProfileSuccessState({required this.profileModel});
  @override
  List<Object> get props => [profileModel];
}
