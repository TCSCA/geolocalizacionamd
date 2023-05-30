part of 'amd_pending_bloc.dart';

abstract class AmdPendingState extends Equatable {
  const AmdPendingState();
}

class AmdPendingInitial extends AmdPendingState {
  @override
  List<Object> get props => [];
}

class IsAmdPendingState extends AmdPendingState {
  AmdPendingModel amdPendingModel;

  IsAmdPendingState({required this.amdPendingModel});

  @override
  List<Object?> get props => [amdPendingModel];
}

class IsNotAmdPendingState extends AmdPendingState {

  final String message;
  const IsNotAmdPendingState({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];}

class IsLoadingAmdPendingState extends AmdPendingState {
  @override
  List<Object?> get props => [];
}

class AmdPendingErrorState extends AmdPendingState {

  final String message;
  const AmdPendingErrorState({required this.message});

  @override
  List<Object?> get props => [message];

}
