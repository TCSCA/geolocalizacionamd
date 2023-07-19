import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpansionTitleWidget extends StatelessWidget {
  String? orderNumber;
  int? dateOrderDay;
  int? dateOrderMonth;
  int? dateOrderYear;
  String? fullNamePatient;
  String? identificationDocument;
  String? phoneNumberPatient;
  String? address;
  String? applicantDoctor;
  String? phoneNumberDoctor;
  String? typeService;
  String? linkAmd;
  String? statusHomeService;

  ExpansionTitleWidget(
      {super.key,
      this.orderNumber,
      this.dateOrderDay,
      this.dateOrderMonth,
      this.dateOrderYear,
      this.fullNamePatient,
      this.identificationDocument,
      this.phoneNumberPatient,
      this.address,
      this.applicantDoctor,
      this.phoneNumberDoctor,
      this.typeService,
      this.linkAmd,
      this.statusHomeService});

  double interlineado = 7.0;
  double tamanioLetra = 15.0;
  double tamanioTitulo = 16.0;

  @override
  Widget build(BuildContext context) {

    final String day;
    final String month;

    day = dateOrderDay! < 10 ? '0$dateOrderDay' : dateOrderDay.toString();
    month = dateOrderMonth! < 10 ? '0$dateOrderMonth' : dateOrderMonth.toString();

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
                orderNumber!,
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
                  '$day-$month-$dateOrderYear',
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
                    fullNamePatient!,
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
                  identificationDocument!,
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
                  phoneNumberPatient!,
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
                  child:
                      Text(address!, style: TextStyle(fontSize: tamanioLetra)),
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
                    applicantDoctor!,
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
                  phoneNumberDoctor!,
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
                  typeService!,
                  style: TextStyle(fontSize: tamanioLetra),
                )
              ],
            ),
            SizedBox(height: interlineado),
             Row(
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
                    Uri.parse(linkAmd!),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: const Text('Ver formulario'),
                ),
              ],
            ),
            SizedBox(height: interlineado),
          ],
        ),
      ],
    );
  }
}
