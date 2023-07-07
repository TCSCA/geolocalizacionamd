import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'amd_history_event.dart';
part 'amd_history_state.dart';

class AmdHistoryBloc extends Bloc<AmdHistoryEvent, AmdHistoryState> {
  AmdHistoryBloc() : super(AmdHistoryInitial()) {
    on<AmdHistoryEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetAmdHistoryEvent>((event, emit) {
      emit(AmdHistoryLoadingState());



    });
  }
}
