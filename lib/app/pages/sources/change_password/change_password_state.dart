part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class ChangePasswordSuccessState extends ChangePasswordState {
  final ChangePasswordModel changePasswordModel;

  const ChangePasswordSuccessState({required this.changePasswordModel});

  @override
  // TODO: implement props
  List<Object?> get props => [changePasswordModel];
}

class ChangePasswordErrorState extends ChangePasswordState {

  final String messageError;

  const ChangePasswordErrorState({required this.messageError});
  @override
  // TODO: implement props
  List<Object?> get props => [messageError];
}

class ChangePasswordLoadingState extends ChangePasswordState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}