part of 'gender_bloc.dart';

abstract class GenderState extends Equatable {
  const GenderState();
}

class GenderInitial extends GenderState {

  @override
  List<Object> get props => [];
}

class GenderDataSuccessState extends GenderState {
  final GenderMap genderMap;

  const GenderDataSuccessState({required this.genderMap});
  @override
  List<Object?> get props => [genderMap];

}

class GenderDataErrorState extends GenderState {
  const GenderDataErrorState({required this.messageError});

   final String messageError;
  @override
  List<Object?> get props => [];
}
