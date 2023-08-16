part of 'digital_signature_bloc.dart';

abstract class DigitalSignatureEvent extends Equatable {
  const DigitalSignatureEvent();
}

class ConsultDigitalSignatureeEvent extends DigitalSignatureEvent {

  @override
  List<Object?> get props => [];
}

class SelectDoctorSignature extends DigitalSignatureEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
