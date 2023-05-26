part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class ProcessLoginEvent extends LoginEvent {
  final String user;
  final String password;
  final String languageCode;
  const ProcessLoginEvent(this.user, this.password, this.languageCode);
  @override
  List<Object> get props => [user, password, languageCode];
}

class ProcessLogoutEvent extends LoginEvent {
  const ProcessLogoutEvent();
  @override
  List<Object> get props => [];
}

class ProcessResetLoginEvent extends LoginEvent {
  final String user;
  final String password;
  final String languageCode;
  const   ProcessResetLoginEvent(this.user, this.password, this.languageCode);
  @override
  List<Object> get props => [user, password, languageCode];
}
