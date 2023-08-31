import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/models/home_service_model.dart';

import '../../../../core/controllers/amd_history_controller.dart';
import '../../../../errors/error_app_exception.dart';
import '../../../../errors/error_general_exception.dart';
import '../../../constants/app_constants.dart';

part 'amd_history_event.dart';

part 'amd_history_state.dart';

class AmdHistoryBloc extends Bloc<AmdHistoryEvent, AmdHistoryState> {
  final AmdHistoryController amdHistoryController;
 List<HomeServiceModel> homeServiceModel = [];
  AmdHistoryBloc({required this.amdHistoryController})
      : super(AmdHistoryInitial()) {
    on<AmdHistoryEvent>((event, emit) {});

    on<GetAmdHistoryEvent>((event, emit) async {
      emit(AmdHistoryLoadingState());
      try {
       homeServiceModel = await amdHistoryController.getHistoryAmdOrderListCtrl();

       List<HomeServiceModel> homeServiceModelF = homeServiceModel.where((i) => i.statusLinkAmd == 'Finalizado').toList();
       List<HomeServiceModel> homeServiceModelP = homeServiceModel.where((i) => i.statusLinkAmd == 'Rechazada').toList();


        emit(AmdHistorySuccessDataState(homeServiceF: homeServiceModelF, homeServiceP: homeServiceModelP));

      } on ErrorAppException catch (exapp) {
        emit(AmdHistoryErrorState(messageError: exapp.message));
      } on ErrorGeneralException catch (exgen) {
        emit(AmdHistoryErrorState(messageError: exgen.message));
      } catch (unknowerror) {
        emit(const AmdHistoryErrorState(
            messageError: AppConstants.codeGeneralErrorMessage));
      }
    });
  }
}
