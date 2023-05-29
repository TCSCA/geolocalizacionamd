import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocalizacionamd/app/core/controllers/amd_pending_controller.dart';
import 'package:geolocalizacionamd/app/core/models/amd_pending_model.dart';

import '../../../../api/mappings/amd_pending_mapping.dart';
import '../../../../errors/error_app_exception.dart';
import '../../../../errors/error_general_exception.dart';

part 'amd_pending_event.dart';

part 'amd_pending_state.dart';

class AmdPendingBloc extends Bloc<AmdPendingEvent, AmdPendingState> {
  AmdPendingModel? amdPendingResult;
  AmdPendingController amdPendingController;

  AmdPendingBloc({required this.amdPendingController}) : super(AmdPendingInitial()) {
    on<OnInitialStateEvent>((event, emit) async {
      try {
        emit(IsLoadingAmdPendingState());

        amdPendingResult =
            await amdPendingController.doConsultDataAmdPending();

        if (amdPendingResult == null) {
          emit(IsNotAmdPending());
        } else {
          emit(const IsAmdPending().copyWith(
              orderTime: amdPendingResult?.orderTime,
              orderId: amdPendingResult?.orderId,
              patientName: amdPendingResult?.patientName,
              idDocumentationPatient: amdPendingResult?.idDocumentationPatient,
              phonePatient: amdPendingResult?.phonePatient,
              state: amdPendingResult?.state,
              city: amdPendingResult?.city,
              direction: amdPendingResult?.direction,
              doctorName: amdPendingResult?.doctorName,
              phoneDoctor: amdPendingResult?.phoneDoctor,
              serviceType: amdPendingResult?.serviceType));
        }
      } catch (err) {}
    });
  }
}
