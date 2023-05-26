import 'package:flutter/material.dart';
import 'package:geolocalizacionamd/app/pages/widgets/amd_pending_card_widget.dart';
import 'package:geolocalizacionamd/app/pages/widgets/nearby_doctors%20.dart';
import 'package:geolocalizacionamd/app/pages/widgets/title_bar_widget.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfbfcff),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Image.asset(
                    'assets/images/telemedicina24_logo_azul_lineal.png',
                    width: 270,
                    height: 90,
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.menu,
                        size: 35.0,
                      ))
                ],
              ),
              Container(
                color: const Color(0xFFfbfcff),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xff2B5178),
                          radius: 70,
                          child: CircleAvatar(
                            backgroundColor: Color(0xff2B5178),
                            radius: 90,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/doctor_1.jpg'), //NetworkImage
                              radius: 55,
                            ), //CircleAvatar
                          ), //CircleAvatar
                        ),
                        const SizedBox(width: 5.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Bienvenido(a)',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text('Argenis Mendez',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25.0),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 220,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                      const Color(0xff273456).withOpacity(0.9),
                      const Color(0xff2B5178).withOpacity(0.8)
                    ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(80.0)),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(10.0, 10.0),
                          blurRadius: 20.0,
                          color: const Color(0xff2B5178).withOpacity(0.7))
                    ]),
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 25.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ten presente:',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        'Nuestros pacientes deben recibir un trato digno y respetuoso en cualquier momento y bajo cualquier circunstancia.',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      /* const SizedBox(
                        height: 5.0,
                      ),
                      const Text(
                        'en cualquier momento y bajo cualquier circunstancia.',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ), */
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          Row(
                            children: const [
                              Text('Disponible para atender:',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white)),
                              /* Icon(
                                Icons.arrow_right_alt,
                                size: 33,
                                color: Colors.white,
                              ) */
                            ],
                          ),
                          Expanded(child: Container()),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60.0),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xff273456),
                                      blurRadius: 10.0,
                                      offset: Offset(4.0, 5.0))
                                ]),
                            child: LiteRollingSwitch(
                                width: 150.0,
                                value: false,
                                textOn: 'Disponible',
                                textOff: 'No disponible',
                                colorOn: Colors.green,
                                colorOff: Colors.grey,
                                textOffColor: Colors.white,
                                textOnColor: Colors.white,
                                iconOn: Icons.person_pin_circle,
                                iconOff: Icons.power_settings_new,
                                onChanged: (bool state) {
                                  print(
                                      'onChanged turned ${(state) ? 'on' : 'off'}');
                                },
                                onTap: () {},
                                onDoubleTap: () {},
                                onSwipe: () {}),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              const TitleBar(title: 'Atenciones Pendientes hoy'),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: AmdPendingCard(
                        name: 'name',
                        color: Colors
                            .red), /*Row(
                    children: [
                      AmdPendingCard(
                        name: 'Paciente Uno',
                        color: Colors.blue.shade900,
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      AmdPendingCard(
                        name: 'Paciente dos',
                        color: Colors.lightBlue.shade100,
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      AmdPendingCard(
                        name: 'Paciente Tres',
                        color: Colors.lightBlue.shade100,
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      AmdPendingCard(
                        name: 'Paciente Cuatro',
                        color: Colors.lightBlue.shade100,
                      )
                    ],
                  ),
                ) */
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
