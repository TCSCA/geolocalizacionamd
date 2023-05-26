part of 'amd_pending_bloc.dart';

abstract class AmdPendingEvent extends Equatable {
  const AmdPendingEvent();
}

class OnInitialStateEvent extends AmdPendingEvent {

OnInitialStateEvent();
  @override
  List<Object?> get props => [];
}
