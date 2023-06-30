part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginShowLoadingState extends LoginState {
  const LoginShowLoadingState();
  @override
  List<Object> get props => [];
}

class LoginSuccessState extends LoginState {
  final UserModel user;
  final List<MenuModel> listMenu;
  const LoginSuccessState({required this.user, required this.listMenu});
  @override
  List<Object> get props => [user, listMenu];
}

class LoginErrorState extends LoginState {
  final String message;
  const LoginErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class LoginActiveState extends LoginState {
  final String message;
  const LoginActiveState({required this.message});
  @override
  List<Object> get props => [message];
}

class LogoutSuccessState extends LoginState {
  const LogoutSuccessState();
  @override
  List<Object> get props => [];
}

class ShowFirebaseKeyState extends LoginState {
  final String firebaseKey;
  const ShowFirebaseKeyState({required this.firebaseKey});
  @override
  List<Object> get props => [firebaseKey];
}

class LogoutDoctorInAttentionState extends LoginState {
  final String message;
  const LogoutDoctorInAttentionState({required this.message});
  @override
  List<Object> get props => [message];
}
