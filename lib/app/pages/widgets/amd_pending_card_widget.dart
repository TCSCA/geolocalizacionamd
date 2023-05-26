import 'package:flutter/material.dart';

class AmdPendingCard extends StatelessWidget {
  final String name;
  final Color color;
  const AmdPendingCard({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(10.0, 10.0),
            blurRadius: 20.0,
            color: const Color(0xff2B5178).withOpacity(0.7))
      ]),
      child: Card(
        margin: const EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(color: Color(0xff2B5178), width: 1.0)),
        color: const Color(0xFFfbfcff).withOpacity(0.5),
        //shadowColor: const Color(0xff2B5178).withOpacity(0.7),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Image.asset('assets/images/gps_doctor_image.png'),
                title: const Text('Orden Nro. 258746'),
                subtitle: Column(
                  children: [
                    const SizedBox(height: 3.0),
                    Row(
                      children: const [
                        Text('Paciente:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Ruperto Lugo')
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Row(
                      children: const [
                        Text('Teléfono:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('04241234567')
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Row(
                      children: const [
                        Text('Doctor Solicitante:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Jhoander Armas')
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Row(
                      children: const [
                        Text('Fecha y Hora:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('17-05-2023 3:40PM')
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          elevation: 5,
                          side: const BorderSide(
                              width: 2, color: Color(0xffFFFFFF)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xffF96352), Color(0xffD84835)]),
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: const Text(
                            'Rechazar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xffFFFFFF),
                                fontFamily: 'TitlesHighlight',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  const SizedBox(width: 16),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          elevation: 5,
                          side: const BorderSide(
                              width: 2, color: Color(0xffFFFFFF)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xff2B5178), Color(0xff273456)]),
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: const Text(
                            'Confirmar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Color(0xffFFFFFF),
                                fontFamily: 'TitlesHighlight',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
