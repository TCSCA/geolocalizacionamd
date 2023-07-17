import 'package:flutter/material.dart';


class ExpansionTitleWidget extends StatelessWidget {
   ExpansionTitleWidget({super.key});

    double interlineado = 7.0;
    double tamanioLetra = 15.0;
    double tamanioTitulo = 16.0;

    @override
    Widget build(BuildContext context) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            leading: CircleAvatar(
              //backgroundColor: Colors.white,
                radius: 25.0,
                child: Image.asset(
                  "assets/images/gps_doctor_image.png",
                  width: 42.0,
                  height: 42.0,
                )),
            title: Row(
              children: [
                Text('Nro. de Orden: ',
                    style: TextStyle(
                        fontSize: tamanioTitulo, fontWeight: FontWeight.bold)),
                Text(
                  'CS000511',
                  style: TextStyle(fontSize: tamanioTitulo),
                )
              ],
            ),
            subtitle: Row(
              children: [
                Text('Fecha: ',
                    style: TextStyle(
                        fontSize: tamanioTitulo, fontWeight: FontWeight.bold)),
                Flexible(
                  child: Text(
                    '06-06-2023 03:18 PM',
                    style: TextStyle(fontSize: tamanioTitulo),
                  ),
                )
              ],
            ),
            children: [
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  Text('Nombre del Paciente: ',
                      style: TextStyle(
                          fontSize: tamanioLetra, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  Flexible(
                    child: Text(
                      'Juan Antonio Gonzalez Gonzalez',
                      style: TextStyle(fontSize: tamanioLetra),
                    ),
                  )
                ],
              ),
              SizedBox(height: interlineado),
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  Text('Documento de identidad: ',
                      style: TextStyle(
                          fontSize: tamanioLetra, fontWeight: FontWeight.bold)),
                  Text(
                    '20000000',
                    style: TextStyle(fontSize: tamanioLetra),
                  )
                ],
              ),
              SizedBox(height: interlineado),
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  Text('Teléfono: ',
                      style: TextStyle(
                          fontSize: tamanioLetra, fontWeight: FontWeight.bold)),
                  Text(
                    '04241234567',
                    style: TextStyle(fontSize: tamanioLetra),
                  )
                ],
              ),
              SizedBox(height: interlineado),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 20.0),
                  Text('Dirección del paciente:',
                      style: TextStyle(
                          fontSize: tamanioLetra, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 20.0),
                  Flexible(
                    child: Text(
                        'Venezuela, Carabobo, Montalban, al lado del colegio verde con azul.',
                        style: TextStyle(fontSize: tamanioLetra)),
                  )
                ],
              ),
              SizedBox(height: interlineado),
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  Text('Doctor Solicitante:',
                      style: TextStyle(
                          fontSize: tamanioLetra, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  Flexible(
                    child: Text(
                      'Jhoander Jose Armas Padron',
                      style: TextStyle(fontSize: tamanioLetra),
                    ),
                  )
                ],
              ),
              SizedBox(height: interlineado),
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  Text('Teléfono del Doctor: ',
                      style: TextStyle(
                          fontSize: tamanioLetra, fontWeight: FontWeight.bold)),
                  Text(
                    '04141234567',
                    style: TextStyle(fontSize: tamanioLetra),
                  )
                ],
              ),
              SizedBox(height: interlineado),
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  Text('Tipo de Servicio: ',
                      style: TextStyle(
                          fontSize: tamanioLetra, fontWeight: FontWeight.bold)),
                  Text(
                    'AMD',
                    style: TextStyle(fontSize: tamanioLetra),
                  )
                ],
              ),
              SizedBox(height: interlineado),
              /* Row(
              children: [
                const SizedBox(width: 20.0),
                Text('Formulario AMD: ',
                    style: TextStyle(
                        fontSize: tamanioLetra, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 20.0),
                InkWell(
                  onTap: () => launchUrl(
                    Uri.parse('https://n9.cl/vjupm'),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: const Text('https://n9.cl/vjupm'),
                ),
              ],
            ),
            SizedBox(height: interlineado), */
            ],
          ),
        ],
      );
    }
}
