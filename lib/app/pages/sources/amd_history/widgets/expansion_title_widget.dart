import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/dialog/custom_dialog_box.dart';
import '../../../../shared/loading/loading_builder.dart';
import '../../../constants/app_constants.dart';
import '../../../messages/app_messages.dart';
import '/app/pages/styles/app_styles.dart';
import 'bloc/amd_form_bloc.dart';
import 'dart:io' as io;

class ExpansionTitleWidget extends StatelessWidget {
  final String? orderNumber;
  final int? idMedicalOrder;
  final int? dateOrderDay;
  final int? dateOrderMonth;
  final int? dateOrderYear;
  final String? fullNamePatient;
  final String? identificationDocument;
  final String? phoneNumberPatient;
  final String? address;
  final String? applicantDoctor;
  final String? phoneNumberDoctor;
  final String? typeService;
  final String? linkAmd;
  final String? statusHomeService;
  final String? statusOrder;

  const ExpansionTitleWidget(
      {super.key,
      this.orderNumber,
      this.idMedicalOrder,
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
      this.statusHomeService,
      this.statusOrder});

  final double interlineado = 7.0;
  final double tamanioLetra = 15.0;
  final double tamanioTitulo = 16.0;

  @override
  Widget build(BuildContext context) {
    final String day;
    final String month;

    day = dateOrderDay! < 10 ? '0$dateOrderDay' : dateOrderDay.toString();
    month =
        dateOrderMonth! < 10 ? '0$dateOrderMonth' : dateOrderMonth.toString();

    return /*BlocConsumer<AmdFormBloc, AmdFormState>(
      listener: (context, state) async {
        if (state is AmdRenewFormSuccessState) {
          launchUrl(
            Uri.parse(state.urlFormRenew),
            mode: LaunchMode.externalApplication,
          );
        }
        if (state is AmdViewFormArchiveSuccessState) {
          final io.Directory root = await getTemporaryDirectory();
          final io.File filePath;

          filePath = io.File('${root.path}/${state.fileAmdFormModel.fileName}');

          await filePath.writeAsBytes(state.fileAmdFormModel.file);
          final result = await OpenFile.open(filePath.path);

          print(state.fileAmdFormModel);
        }
      },
      builder: (context, state) {
        return*/
        Column(
      children: <Widget>[
        ExpansionTile(
          iconColor: AppStyles.colorBluePrimary,
          collapsedIconColor: AppStyles.colorBlack,
          textColor: AppStyles.colorBluePrimary,
          collapsedTextColor: AppStyles.colorBlack,
          leading: CircleAvatar(
              backgroundColor: AppStyles.colorBluePrimary,
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
                  '$day/$month/$dateOrderYear',
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
            if (statusHomeService == 'Finalizado') ...[
              Row(
                children: [
                  const SizedBox(width: 20.0),
                  Text('Formulario AMD: ',
                      style: TextStyle(
                          fontSize: tamanioLetra, fontWeight: FontWeight.bold)),
                  BlocConsumer<AmdFormBloc, AmdFormState>(
                    listener: (context, state) async {
                      if (state is AmdFormLoading) {
                        LoadingBuilder(context)
                            .showLoadingIndicator('Procesando su solicitud');
                      }
                      if (state is AmdRenewFormSuccessState) {
                        LoadingBuilder(context).hideOpenDialog();
                        launchUrl(
                          Uri.parse(state.urlFormRenew),
                          mode: LaunchMode.externalApplication,
                        );
                      }
                      if (state is AmdViewFormArchiveSuccessState) {
                        LoadingBuilder(context).hideOpenDialog();
                        final io.Directory root = await getTemporaryDirectory();
                        final io.File filePath;

                        filePath = io.File(
                            '${root.path}/${state.fileAmdFormModel.fileName}');

                        await filePath
                            .writeAsBytes(state.fileAmdFormModel.file);
                        final result = await OpenFile.open(filePath.path);
                      }

                      if (state is AmdRenewFormErrorState) {
                        if (context.mounted) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: AppMessages().getMessageTitle(
                                      context, AppConstants.statusError),
                                  descriptions: AppMessages()
                                      .getMessage(context, state.messageError),
                                  isConfirmation: false,
                                  dialogAction: () {},
                                  type: AppConstants.statusError,
                                  isdialogCancel: false,
                                  dialogCancel: () {},
                                );
                              });
                        }
                      }

                      if (state is AmdViewFormArchiveErrorState) {
                        // ignore: use_build_context_synchronously
                        LoadingBuilder(context).hideOpenDialog();
                        if (context.mounted) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: AppMessages().getMessageTitle(
                                      context, AppConstants.statusError),
                                  descriptions: AppMessages()
                                      .getMessage(context, state.messageError),
                                  isConfirmation: false,
                                  dialogAction: () {},
                                  type: AppConstants.statusError,
                                  isdialogCancel: false,
                                  dialogCancel: () {},
                                );
                              });
                        }
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          /*if (statusLinkAmd == 'Generado' ||
                          statusLinkAmd == 'Expirado')*/
                          if (statusOrder == 'Pendiente')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 5.0),
                                InkWell(
                                  onTap: () {
                                    // if (statusOrder == 'Pendiente') {
                                    BlocProvider.of<AmdFormBloc>(context).add(
                                        AmdRenewFormEvent(
                                            idMedicalOrder: idMedicalOrder!));
                                    /*launchUrl(
                                    Uri.parse(linkAmd!),
                                    mode: LaunchMode.externalApplication,
                                  );*/
                                    /*} else {
                                  BlocProvider.of<AmdFormBloc>(context).add(
                                      AmdRenewFormEvent(
                                          idMedicalOrder: idMedicalOrder!));
                                }*/
                                  },
                                  child: Text('Ver formulario',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary)),
                                ),
                              ],
                            ),
                          if (statusOrder == 'Procesada')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 5.0),
                                InkWell(
                                  onTap: () {
                                    BlocProvider.of<AmdFormBloc>(context).add(
                                        AmdViewFormEvent(
                                            idMedicalOrder: idMedicalOrder!));
                                  },
                                  child: Text('Ver PDF',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary)),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 20.0),
            ]
          ],
        ),
      ],
    );
    /*},
    );*/
  }
}
