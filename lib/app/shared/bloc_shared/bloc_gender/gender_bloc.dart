import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../api/mappings/gender_mapping.dart';
import '../../../core/controllers/profile_controller.dart';

part 'gender_event.dart';
part 'gender_state.dart';

class GenderBloc extends Bloc<GenderEvent, GenderState> {

  final ProfileController profileController;
  GenderMap? genderMap;
  GenderBloc({required this.profileController}) : super(GenderInitial()) {
    on<GenderEvent>((event, emit) {});

    on<ConsultAllGenderEvent>((event, emit) async {

   genderMap = await profileController.doGetAllGender();

   emit(GenderDataSuccessState(genderMap: genderMap!));
    });
  }
}
