part of 'amd_history_bloc.dart';

abstract class AmdHistoryState extends Equatable {
  const AmdHistoryState();
}

class AmdHistoryInitial extends AmdHistoryState {
  @override
  List<Object> get props => [];
}

class AmdHistorySuccessDataState extends AmdHistoryState{


  @override
  List<Object?> get props => [];
}

class AmdHistoryLoadingState extends AmdHistoryState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AmdHistoryErrorState extends AmdHistoryState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}
