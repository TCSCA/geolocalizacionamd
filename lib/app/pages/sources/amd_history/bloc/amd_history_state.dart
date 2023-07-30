part of 'amd_history_bloc.dart';

abstract class AmdHistoryState extends Equatable {
  const AmdHistoryState();
}

class AmdHistoryInitial extends AmdHistoryState {
  @override
  List<Object> get props => [];
}

class AmdHistorySuccessDataState extends AmdHistoryState{

  final List<HomeServiceModel> homeServiceF;
  final List<HomeServiceModel> homeServiceP;

  const AmdHistorySuccessDataState({required this.homeServiceP, required this.homeServiceF});
  @override
  List<Object?> get props => [homeServiceP, homeServiceF];
}

class AmdHistoryLoadingState extends AmdHistoryState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AmdHistoryErrorState extends AmdHistoryState {

 final String messageError;

  const AmdHistoryErrorState({required this.messageError});
  @override
  List<Object?> get props => [messageError];

}
