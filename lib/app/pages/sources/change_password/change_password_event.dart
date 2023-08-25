part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();
}

class SendToServiceChangePassword extends ChangePasswordEvent {
  final String password;
  final String username;

  const SendToServiceChangePassword(
      {required this.password, required this.username});

  @override
  // TODO: implement props
  List<Object?> get props => [password];
}