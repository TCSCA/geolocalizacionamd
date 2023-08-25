part of 'amd_form_bloc.dart';

abstract class AmdFormEvent extends Equatable {
  const AmdFormEvent();
}

class AmdRenewFormEvent extends AmdFormEvent {
  const AmdRenewFormEvent({required this.idMedicalOrder});

  final int idMedicalOrder;


  @override
  List<Object?> get props => [];
}

class AmdViewFormEvent extends AmdFormEvent {
  @override
  List<Object?> get props => [];
}
