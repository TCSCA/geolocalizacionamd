part of 'amd_pending_bloc.dart';

abstract class AmdPendingState extends Equatable {
  const AmdPendingState();
}

class AmdPendingInitial extends AmdPendingState {
  @override
  List<Object> get props => [];
}

class IsAmdPending extends AmdPendingState {
  final String orderTime;
  final int orderId;
  final String patientName;
  final String idDocumentationPatient;
  final String phonePatient;
  final String state;
  final String city;
  final String direction;
  final String doctorName;
  final String phoneDoctor;
  final String serviceType;

  const IsAmdPending(
      {this.orderTime = '',
      this.orderId = 0,
      this.patientName = '',
      this.idDocumentationPatient = '',
      this.phonePatient = '',
      this.state = '',
      this.city = '',
      this.direction = '',
      this.doctorName = '',
      this.phoneDoctor = '',
      this.serviceType = ''});

  copyWith(
          {String? orderTime,
          int? orderId,
          String? patientName,
          String? idDocumentationPatient,
          String? phonePatient,
          String? state,
          String? city,
          String? direction,
          String? doctorName,
          String? phoneDoctor,
          String? serviceType}) =>
      IsAmdPending(
          orderTime: orderTime ?? this.orderTime,
          orderId: orderId ?? this.orderId,
          patientName: patientName ?? this.patientName,
          idDocumentationPatient:
              idDocumentationPatient ?? this.idDocumentationPatient,
          phonePatient: phonePatient ?? this.phonePatient,
          state: state ?? this.state,
          city: city ?? this.city,
          direction: direction ?? this.direction,
          doctorName: doctorName ?? this.doctorName,
          phoneDoctor: phoneDoctor ?? this.phoneDoctor,
          serviceType: serviceType ?? this.serviceType);

  @override
  List<Object?> get props => [
        orderTime,
        orderId,
        patientName,
        idDocumentationPatient,
        phonePatient,
        state,
        city,
        direction,
        doctorName,
        phoneDoctor,
        serviceType
      ];
}

class IsNotAmdPending extends AmdPendingState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class IsLoadingAmdPendingState extends AmdPendingState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
