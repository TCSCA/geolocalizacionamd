import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AmdHistoryPage extends StatefulWidget {
  const AmdHistoryPage({super.key});

  @override
  State<AmdHistoryPage> createState() => _AmdHistoryPageState();
}

class _AmdHistoryPageState extends State<AmdHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff273456),
          title: const Text('Historial AMD'),
          bottom: TabBar(
              labelColor: const Color(0xffD84835),
              unselectedLabelColor: Colors.white,
              indicatorColor: const Color(0xffD84835),
              indicatorWeight: 5,
              /* indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), // Creates border
                  color: Colors.greenAccent), */
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(FontAwesomeIcons.houseMedicalCircleCheck,
                          size: 30.0),
                      SizedBox(
                        width: 17.0,
                      ),
                      Text(
                        "Confirmadas",
                        style: TextStyle(fontSize: 17.0),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(FontAwesomeIcons.houseMedicalCircleXmark, size: 30.0),
                    SizedBox(
                      width: 17.0,
                    ),
                    Text(
                      "Rechazadas",
                      style: TextStyle(fontSize: 17.0),
                    )
                  ],
                ),
              ]),
        ),
        body: TabBarView(
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
                          leading:
                              Image.asset('assets/images/gps_doctor_image.png'),
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
                          leading:
                              Image.asset('assets/images/gps_doctor_image.png'),
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
    );
  }
}
