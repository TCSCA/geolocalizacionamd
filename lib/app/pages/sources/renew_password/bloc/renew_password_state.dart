part of 'renew_password_bloc.dart';

abstract class RenewPasswordState extends Equatable {
  const RenewPasswordState();
}

class RenewPasswordInitial extends RenewPasswordState {
  @override
  List<Object> get props => [];
}
class SuccessRenewPassword extends RenewPasswordState {

  final RenewPasswordModel renewPasswordModel;

  const SuccessRenewPassword({required this.renewPasswordModel});
  @override
  List<Object?> get props => [renewPasswordModel];
}

class IsLoadingState extends RenewPasswordState {
  @override
  List<Object?> get props => [];
}

class ErrorRenewPasswordState extends RenewPasswordState {

  final String messageError;

  const ErrorRenewPasswordState({required this.messageError});

  @override
  List<Object?> get props => [messageError];

}
