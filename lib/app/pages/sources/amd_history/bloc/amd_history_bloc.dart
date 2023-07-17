import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/controllers/amd_history_controller.dart';

part 'amd_history_event.dart';
part 'amd_history_state.dart';

class AmdHistoryBloc extends Bloc<AmdHistoryEvent, AmdHistoryState> {

  final AmdHistoryController amdHistoryController;

  AmdHistoryBloc({required this.amdHistoryController}) : super(AmdHistoryInitial()) {
    on<AmdHistoryEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetAmdHistoryEvent>((event, emit) async {
      emit(AmdHistoryLoadingState());

      await amdHistoryController.getHistoryAmdOrderListCtrl();


    });
  }
}
