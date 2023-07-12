part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class ConnectDoctorAmdEvent extends MainEvent {
  final String locationState;
  final String locationCity;
  const ConnectDoctorAmdEvent(
      {required this.locationState, required this.locationCity});
  @override
  List<Object> get props => [locationState, locationCity];
}

class DisconectDoctorAmdEvent extends MainEvent {
  @override
  List<Object> get props => [];
}

class CancelButtonAmdEvent extends MainEvent {
  final bool currentToggleSwitch;
  const CancelButtonAmdEvent({required this.currentToggleSwitch});
  @override
  List<Object> get props => [currentToggleSwitch];
}

class ShowHomeServiceAssignedEvent extends MainEvent {
  const ShowHomeServiceAssignedEvent();
  @override
  List<Object> get props => [];
}

class ShowLocationDoctorStatesEvent extends MainEvent {
  final String countryCode;
  const ShowLocationDoctorStatesEvent(this.countryCode);
  @override
  List<Object> get props => [countryCode];
}

class ShowLocationDoctorCitiesEvent extends MainEvent {
  final String stateCode;
  const ShowLocationDoctorCitiesEvent(this.stateCode);
  @override
  List<Object> get props => [stateCode];
}

class ConfirmAmdEvent extends MainEvent {
  final int idHomeService;
  const ConfirmAmdEvent(this.idHomeService);
  @override
  List<Object> get props => [idHomeService];
}

class DisallowAmdEvent extends MainEvent {
  final int idHomeService;
  final String idReason;
  const DisallowAmdEvent(this.idHomeService, this.idReason);
  @override
  List<Object> get props => [idHomeService, idReason];
}

class CompleteAmdEvent extends MainEvent {
  final int idHomeService;
  final String idReason;
  const CompleteAmdEvent(this.idHomeService, this.idReason);
  @override
  List<Object> get props => [idHomeService, idReason];
}

class ShowHomeServiceInAttentionEvent extends MainEvent {
  const ShowHomeServiceInAttentionEvent();
  @override
  List<Object> get props => [];
}

class ChangeLocationDoctorCityEvent extends MainEvent {
  final String cityCode;
  const ChangeLocationDoctorCityEvent(this.cityCode);
  @override
  List<Object> get props => [cityCode];
}

class ShowReasonRejectionStatesEvent extends MainEvent {
  final HomeServiceModel homeServiceAssigned;
  const ShowReasonRejectionStatesEvent(this.homeServiceAssigned);
  @override
  List<Object> get props => [homeServiceAssigned];
}

class ShowReasonCompleteStatesEvent extends MainEvent {
  final HomeServiceModel homeServiceAssigned;
  const ShowReasonCompleteStatesEvent(this.homeServiceAssigned);
  @override
  List<Object> get props => [homeServiceAssigned];
}
