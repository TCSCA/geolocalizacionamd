part of 'renew_password_bloc.dart';

abstract class RenewPasswordEvent extends Equatable {
  const RenewPasswordEvent();
}

class SendEmailToRenewPasswordEvent extends RenewPasswordEvent {
  final String email;

  const SendEmailToRenewPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}
