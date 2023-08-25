part of 'amd_form_bloc.dart';

abstract class AmdFormState extends Equatable {
  const AmdFormState();
}

class AmdFormInitial extends AmdFormState {
  @override
  List<Object> get props => [];
}

class AmdFormLoading extends AmdFormState {
  @override
  List<Object> get props => [];
}

class AmdRenewFormSuccessState extends AmdFormState {
  @override
  List<Object?> get props => [];
}

class AmdRenewFormErrorState extends AmdFormState {
  @override
  List<Object?> get props => [];
}

class AmdViewFormArchiveSuccessState extends AmdFormState {
  @override
  List<Object?> get props => [];
}

class AmdViewFormArchiveErrorState extends AmdFormState {
  @override
  List<Object?> get props => [];
}

class AmdFormErrorState extends AmdFormState {

  @override
  List<Object?> get props => [];

}