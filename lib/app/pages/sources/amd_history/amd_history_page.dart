import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/pages/widgets/common_widgets.dart';

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
        child: Scaffold(
          appBar: generateAppBarWithTabBar(context: context),
          body: MultiBlocListener(
            listeners: [
              //NavigationBloc y LogoutBloc comunes en todas las paginas.
              AppCommonWidgets.listenerNavigationBloc(),
              AppCommonWidgets.listenerLogoutBloc()
            ],
            child: TabBarView(
              children: [
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
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          //mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: 3.0),
                            ListTile(
                              leading: Image.asset(
                                  'assets/images/gps_doctor_image.png'),
                              /* trailing: TextButton(
                                          onPressed: () => {}, child: const Text('Ver')), */
                              title: const Text('Orden Nro. 258746'),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: const [
                                      Text('Paciente:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Ruperto Lugo')
                                    ],
                                  ),
                                  const SizedBox(height: 3.0),
                                  Row(
                                    children: const [
                                      Text('Teléfono:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('04241234567')
                                    ],
                                  ),
                                  const SizedBox(height: 3.0),
                                  Row(
                                    children: const [
                                      Text('Doctor Solicitante:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Jhoander Armas')
                                    ],
                                  ),
                                  const SizedBox(height: 3.0),
                                  Row(
                                    children: const [
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
                            /* Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        TextButton(
                                            onPressed: () => {},
                                            child: const Text('Ver Detalle')),
                                      ],
                                    ) */
                          ],
                        ),
                      ),
                    )
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
                              subtitle: Column(
                                children: [
                                  const SizedBox(height: 3.0),
                                  Row(
                                    children: const [
                                      Text('Paciente:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Ruperto Lugo')
                                    ],
                                  ),
                                  const SizedBox(height: 3.0),
                                  Row(
                                    children: const [
                                      Text('Teléfono:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('04241234567')
                                    ],
                                  ),
                                  const SizedBox(height: 3.0),
                                  Row(
                                    children: const [
                                      Text('Doctor Solicitante:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Jhoander Armas')
                                    ],
                                  ),
                                  const SizedBox(height: 3.0),
                                  Row(
                                    children: const [
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
            ),
          ),
        ),
      ),
    );
  }
}
