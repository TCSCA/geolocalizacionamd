import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/method/back_button_action.dart';
import '/app/pages/widgets/common_widgets.dart';
import '/app/pages/widgets/title_bar_widget.dart';
import 'widgets/main_widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with MainWidgets {
  final double dataSpaceHeight = 25.0;
  /*final MainBloc _newsBloc =
      MainBloc(doctorCareController: DoctorCareController());*/

  /* @override
  void initState() {
    _newsBloc.add(const ShowHomeServiceAssignedEvent());
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    //MainBloc userMainBloc = BlocProvider.of<MainBloc>(context);
    //userMainBloc.add(const ShowHomeServiceAssignedEvent());
    return WillPopScope(
      onWillPop: () async => backButtonActions(),
      child: SafeArea(
        child: Scaffold(
          appBar: generateAppBar(context: context),
          body: MultiBlocListener(
            listeners: [
              //NavigationBloc y LogoutBloc comunes en todas las paginas.
              AppCommonWidgets.listenerNavigationBloc(),
              AppCommonWidgets.listenerLogoutBloc()
            ],
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: dataSpaceHeight),
                    createDoctorInfo(context: context),
                    SizedBox(height: dataSpaceHeight),
                    serviceAvailabilityDashboard(context: context),
                    SizedBox(height: dataSpaceHeight),
                    const TitleBar(title: 'Atenciones Pendientes:'),
                    const SizedBox(
                      height: 20.0,
                    ),
                    amdInformationAssigned(context: context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
