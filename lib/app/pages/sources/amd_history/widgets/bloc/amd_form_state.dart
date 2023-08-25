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
  const AmdRenewFormSuccessState({required this.urlFormRenew});
  final String urlFormRenew;

  @override
  List<Object?> get props => [urlFormRenew];
}

class AmdRenewFormErrorState extends AmdFormState {
  @override
  List<Object?> get props => [];
}

class AmdViewFormArchiveSuccessState extends AmdFormState {
  const AmdViewFormArchiveSuccessState({required this.fileAmdFormModel});
  final FileAmdFormModel fileAmdFormModel;

  @override
  List<Object?> get props => [fileAmdFormModel];
}

class AmdViewFormArchiveErrorState extends AmdFormState {
  @override
  List<Object?> get props => [];
}

class AmdFormErrorState extends AmdFormState {

  @override
  List<Object?> get props => [];

}