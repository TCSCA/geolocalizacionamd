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

class ProfileLoadingState extends ProfileState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}

class ProfileErrorState extends ProfileState {

 final String messageError;

  const ProfileErrorState({required this.messageError});
  @override
  List<Object?> get props => [messageError];

}