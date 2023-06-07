part of 'renew_password_bloc.dart';

abstract class RenewPasswordEvent extends Equatable {
  const RenewPasswordEvent();
}

class SendEmailToRenewPasswordEvent extends RenewPasswordEvent {
  final String username;

  const SendEmailToRenewPasswordEvent({required this.username});

  @override
  List<Object?> get props => [username];
}
