part of 'amd_pending_bloc.dart';

abstract class AmdPendingEvent extends Equatable {
  const AmdPendingEvent();
}

class ConsultDataAmdPendingEvent extends AmdPendingEvent {
  const ConsultDataAmdPendingEvent();
  @override
  List<Object?> get props => [];
}