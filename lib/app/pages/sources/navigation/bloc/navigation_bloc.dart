import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '/app/core/models/menu_model.dart';
import '/app/core/models/navigation_item_model.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  int currentIndex = 0;
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigationPageEvent>((event, emit) {
      late NavigationItemModel currentPage;
      currentIndex = 0;
      emit(NavigationStartedState());
      currentIndex = event.page;
      currentPage = NavigationItemModel(event.pagesMenu[currentIndex].route,
          event.pagesMenu[currentIndex].descripcion);
      emit(NavigationCurrentChangedState(currentPage: currentPage));
    });
  }
}
