import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/core/controllers/amd_history_controller.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_history/bloc/amd_history_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_history/widgets/expansion_title_widget.dart';
import '../../../shared/method/back_button_action.dart';
import '/app/pages/widgets/common_widgets.dart';
import 'widgets/amd_history_widgets.dart';

class AmdHistoryPage extends StatefulWidget {
  const AmdHistoryPage({super.key});

  @override
  State<AmdHistoryPage> createState() => _AmdHistoryPageState();
}

class _AmdHistoryPageState extends State<AmdHistoryPage>
    with AmdHistoryWidgets {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: WillPopScope(
          onWillPop: () => backButtonActions(),
          child: Scaffold(
            appBar: generateAppBarWithTabBar(context: context),
            body: MultiBlocListener(
              listeners: [
                //NavigationBloc y LogoutBloc comunes en todas las paginas.
                AppCommonWidgets.listenerNavigationBloc(),
                AppCommonWidgets.listenerLogoutBloc()
              ],
              child: BlocProvider(
                create: (context) => AmdHistoryBloc(amdHistoryController: AmdHistoryController())..add(GetAmdHistoryEvent()),
                child: const TabBarViewWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AmdHistoryBloc, AmdHistoryState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                /*Card(
                  margin: const EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                          color: Color(0xff2B5178), width: 1.0)),
                  color: const Color(0xFFfbfcff).withOpacity(0.5),
                  //shadowColor: const Color(0xff2B5178).withOpacity(0.7),

                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 3.0),
                        ListTile(
                          leading: Image.asset(
                              'assets/images/gps_doctor_image.png'),
                          *//* trailing: TextButton(
                                  onPressed: () => {}, child: const Text('Ver')), *//*
                          title: const Text('Orden Nro. 8888888'),
                          subtitle: Column(
                            children: [
                              const Row(
                                children: [
                                  Text('Paciente:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Ruperto Lugo')
                                ],
                              ),
                              const SizedBox(height: 3.0),
                              const Row(
                                children: [
                                  Text('Teléfono:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('04241234567')
                                ],
                              ),
                              const SizedBox(height: 3.0),
                              const Row(
                                children: [
                                  Text('Doctor Solicitante:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Jhoander Armas')
                                ],
                              ),
                              const SizedBox(height: 3.0),
                              const Row(
                                children: [
                                  Text('Fecha y Hora:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('17-05-2023 3:40PM')
                                ],
                              ),
                              TextButton(
                                  onPressed: () => {},
                                  child: const Text('Ver Detalle'))
                            ],
                          ),
                        ),
                        *//* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                    onPressed: () => {},
                                    child: const Text('Ver Detalle')),
                              ],
                            ) *//*
                      ],
                    ),
                  ),
                )*/
                ExpansionTitleWidget()
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                Card(
                  margin: const EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                          color: Color(0xff2B5178), width: 1.0)),
                  color: const Color(0xFFfbfcff).withOpacity(0.5),
                  //shadowColor: const Color(0xff2B5178).withOpacity(0.7),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Image.asset(
                              'assets/images/gps_doctor_image.png'),
                          title: const Text('Rechazo Nro. 258746'),
                          subtitle: const Column(
                            children: [
                              SizedBox(height: 3.0),
                              Row(
                                children: [
                                  Text('Paciente:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Ruperto Lugo')
                                ],
                              ),
                              SizedBox(height: 3.0),
                              Row(
                                children: [
                                  Text('Teléfono:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('04241234567')
                                ],
                              ),
                              SizedBox(height: 3.0),
                              Row(
                                children: [
                                  Text('Doctor Solicitante:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Jhoander Armas')
                                ],
                              ),
                              SizedBox(height: 3.0),
                              Row(
                                children: [
                                  Text('Fecha y Hora:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('17-05-2023 3:40PM')
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
