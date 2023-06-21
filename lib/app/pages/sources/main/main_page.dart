import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/core/controllers/doctor_care_controller.dart';
import 'package:geolocalizacionamd/app/pages/sources/login/bloc/login_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/main/bloc/main_bloc.dart';
import 'package:geolocalizacionamd/app/pages/widgets/amd_pending_card_widget.dart';
import 'package:geolocalizacionamd/app/pages/widgets/common_widgets.dart';
import 'package:geolocalizacionamd/app/pages/widgets/title_bar_widget.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

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
    return SafeArea(
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
                  const TitleBar(title: 'Atenciones Pendientes hoy'),
                  amdInformationAssigned(context: context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
