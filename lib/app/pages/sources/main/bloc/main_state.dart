part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState();
  @override
  List<Object> get props => [];
}

class MainShowLoadingState extends MainState {
  const MainShowLoadingState();
  @override
  List<Object> get props => [];
}

class MainInitial extends MainState {
  final bool doctorAvailable;
  const MainInitial({required this.doctorAvailable});
  @override
  List<Object> get props => [doctorAvailable];
}

class DoctorServiceState extends MainState {
  final bool doctorAvailable;
  final String message;
  const DoctorServiceState(
      {required this.doctorAvailable, required this.message});
  @override
  List<Object> get props => [doctorAvailable, message];
}

class DoctorServiceErrorState extends MainState {
  final bool doctorAvailable;
  final String message;
  const DoctorServiceErrorState(
      {required this.doctorAvailable, required this.message});
  @override
  List<Object> get props => [doctorAvailable, message];
}

class CancelButtonAmdState extends MainState {
  final bool doctorAvailable;
  const CancelButtonAmdState({required this.doctorAvailable});
  @override
  List<Object> get props => [doctorAvailable];
}

class HomeServiceSuccessState extends MainState {
  final HomeServiceModel homeServiceAssigned;
  const HomeServiceSuccessState({required this.homeServiceAssigned});
  @override
  List<Object> get props => [homeServiceAssigned];
}

class HomeServiceErrorState extends MainState {
  final String message;
  const HomeServiceErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class LocationStatesSuccessState extends MainState {
  final List<SelectModel> listStates;
  const LocationStatesSuccessState({required this.listStates});
  @override
  List<Object> get props => [listStates];
}

class LocationCitiesSuccessState extends MainState {
  final List<SelectModel> listCities;
  final String selectedState;
  const LocationCitiesSuccessState(
      {required this.listCities, required this.selectedState});
  @override
  List<Object> get props => [listCities, selectedState];
}

class ConfirmHomeServiceSuccessState extends MainState {
  final HomeServiceModel homeServiceConfirmed;
  const ConfirmHomeServiceSuccessState({required this.homeServiceConfirmed});
  @override
  List<Object> get props => [homeServiceConfirmed];
}

class DisallowHomeServiceSuccessState extends MainState {
  final String message;
  const DisallowHomeServiceSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class CompleteHomeServiceSuccessState extends MainState {
  final String message;
  const CompleteHomeServiceSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class HomeServiceInAttentionState extends MainState {
  final String message;
  const HomeServiceInAttentionState({required this.message});
  @override
  List<Object> get props => [message];
}

class ChangeLocationDoctorCityState extends MainState {
  final String selectedCity;
  const ChangeLocationDoctorCityState({required this.selectedCity});
  @override
  List<Object> get props => [selectedCity];
}

class HomeServiceEmptyState extends MainState {
  const HomeServiceEmptyState();
}
