import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../api/mappings/amd_pending_mapping.dart';
import '../../../../errors/error_app_exception.dart';
import '../../../../errors/error_general_exception.dart';

part 'amd_pending_event.dart';
part 'amd_pending_state.dart';



class AmdPendingBloc extends Bloc<AmdPendingEvent, AmdPendingState> {
  AmdPendingMap? amdPendingResult;

  AmdPendingBloc() : super(AmdPendingInitial()) {
    on<OnInitialStateEvent>(_onInitialStateEvent);
  }


  void _onInitialStateEvent(OnInitialStateEvent event, Emitter<AmdPendingState> emit) async {

    amdPendingResult = await getAmdPending();

    if(amdPendingResult == null) {

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
        serviceType: amdPendingResult?.serviceType
      ));
    }


  }
}

Future<AmdPendingMap?> getAmdPending() async {
  const headerLogger = 'ListsService.getMenu';
  Map<String, dynamic> decodeResp;
  AmdPendingMap opciones;

  try {
    final resp = await rootBundle.loadString('assets/data/amd_pending.json');
    decodeResp = json.decode(resp);

    opciones = AmdPendingMap.fromJson(decodeResp);
  } on ErrorAppException catch (errorapp) {
    rethrow;
  } catch (unknowerror) {
    throw ErrorGeneralException();
  }

  return opciones;
}