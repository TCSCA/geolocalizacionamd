part of 'digital_signature_bloc.dart';

abstract class DigitalSignatureState extends Equatable {
  const DigitalSignatureState();
}

class DigitalSignatureInitial extends DigitalSignatureState {
  @override
  List<Object> get props => [];
}

class DigitalSignatureSuccess extends DigitalSignatureState {

  final Uint8List? doctorSignatureBuild;
  final String? doctorSignaturePath;

  const DigitalSignatureSuccess({this.doctorSignatureBuild, this.doctorSignaturePath});

  @override
  List<Object?> get props => [doctorSignatureBuild, doctorSignaturePath];

}

class LoadingDigitalSignatureState extends DigitalSignatureState{
  @override
  List<Object> get props => [];
}

class DigitalSignatureErrorState extends DigitalSignatureState {
  final String messageError;

  const DigitalSignatureErrorState({required this.messageError});

  @override
  List<Object?> get props => [messageError];
}
