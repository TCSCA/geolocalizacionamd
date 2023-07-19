part of 'amd_history_bloc.dart';

abstract class AmdHistoryEvent extends Equatable {
  const AmdHistoryEvent();
}

class GetAmdHistoryEvent extends AmdHistoryEvent {

  @override
  List<Object?> get props => [];

}
