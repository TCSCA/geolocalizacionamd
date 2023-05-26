part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigationPageEvent extends NavigationEvent {
  final int page;
  final List<MenuModel> pagesMenu;
  const NavigationPageEvent({required this.page, required this.pagesMenu});
  @override
  List<Object> get props => [page, pagesMenu];
}
