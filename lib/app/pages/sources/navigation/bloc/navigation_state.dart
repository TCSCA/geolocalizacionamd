part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();
}

class NavigationInitial extends NavigationState {
  @override
  List<Object> get props => [];
}

class NavigationStartedState extends NavigationState {
  @override
  List<Object> get props => [];
}

class NavigationCurrentChangedState extends NavigationState {
  final NavigationItemModel currentPage;
  const NavigationCurrentChangedState({required this.currentPage});
  @override
  List<Object> get props => [currentPage];
}

class NavigationBackState extends NavigationState {
  @override
  List<Object> get props => [];
}
