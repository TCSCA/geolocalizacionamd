import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '/app/shared/method/back_button_action.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/sources/main/bloc/main_bloc.dart';
import '/app/pages/widgets/common_widgets.dart';
import '/app/shared/dialog/custom_dialog_box.dart';

class AmdPendingPage extends StatefulWidget {
  const AmdPendingPage({super.key});

  @override
  State<AmdPendingPage> createState() => _AmdPendingPageState();
}

class _AmdPendingPageState extends State<AmdPendingPage> {
  @override
  Widget build(BuildContext context) {
    MainBloc userMainBloc = BlocProvider.of<MainBloc>(context);
    userMainBloc.add(const ShowHomeServiceInAttentionEvent());
    return WillPopScope(
      onWillPop: () => backButtonActions(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xff2B5178),
          appBar: AppCommonWidgets.generateAppBar(
              context: context, appBarHeight: 140.0),
          body: MultiBlocListener(
            listeners: [
              //NavigationBloc y LogoutBloc comunes en todas las paginas.
              AppCommonWidgets.listenerNavigationBloc(),
              AppCommonWidgets.listenerLogoutBloc()
            ],
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff2B5178), Color(0xff2B5178)],
                      begin: FractionalOffset(0.0, 0.4),
                      end: Alignment.topRight)),
              child: Column(
                children: [
                  Flexible(
                      child: Container(
                    padding: const EdgeInsets.only(right: 20.0),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(70))),
                    child: BlocConsumer<MainBloc, MainState>(
                      listener: (context, state) {
                        if (state is CompleteHomeServiceSuccessState) {
                          /* BlocProvider.of<MainBloc>(context)
                              .doctorAvailableSwitch = false; */
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: AppMessages().getMessageTitle(
                                      context, AppConstants.statusSuccess),
                                  descriptions: AppMessages()
                                      .getMessage(context, state.message),
                                  isConfirmation: false,
                                  dialogAction: () {},
                                  type: AppConstants.statusSuccess,
                                  isdialogCancel: false,
                                  dialogCancel: () {},
                                );
                              });
                        }
                        if (state is HomeServiceErrorState) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: AppMessages().getMessageTitle(
                                      context, AppConstants.statusError),
                                  descriptions: AppMessages()
                                      .getMessage(context, state.message),
                                  isConfirmation: false,
                                  dialogAction: () {},
                                  type: AppConstants.statusError,
                                  isdialogCancel: false,
                                  dialogCancel: () {},
                                );
                              });
                        }
                      },
                      builder: (context, state) {
                        if (state is ConfirmHomeServiceSuccessState) {
                          return Column(
                            children: [
                              const SizedBox(height: 20.0),
                              Row(
                                children: const [
                                  SizedBox(width: 20.0),
                                  Text(
                                    "Datos de Orden Médica:",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  const SizedBox(width: 20.0),
                                  const Text('Fecha y Hora:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    DateFormat("dd-MM-yyyy hh:mm a").format(
                                        state.homeServiceConfirmed.registerDate),
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const SizedBox(width: 20.0),
                                  const Text('Nro. de Orden:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    state.homeServiceConfirmed.orderNumber,
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: const [
                                  SizedBox(width: 20.0),
                                  Text(
                                    "Datos del Paciente:",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  const SizedBox(width: 20.0),
                                  const Text('Nombre del Paciente:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Flexible(
                                    child: Text(
                                      state.homeServiceConfirmed.fullNamePatient,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const SizedBox(width: 20.0),
                                  const Text('Documento de identidad:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    state.homeServiceConfirmed
                                        .identificationDocument,
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const SizedBox(width: 20.0),
                                  const Text('Teléfono:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    state.homeServiceConfirmed.phoneNumberPatient,
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 20.0),
                                  const Text('Dirección :',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Flexible(
                                    child: Text(
                                        state.homeServiceConfirmed.address,
                                        style: const TextStyle(fontSize: 16)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: const [
                                  SizedBox(width: 20.0),
                                  Text(
                                    "Datos del Doctor:",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  const SizedBox(width: 20.0),
                                  const Text('Doctor Solicitante:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Flexible(
                                    child: Text(
                                      state.homeServiceConfirmed.applicantDoctor,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const SizedBox(width: 20.0),
                                  const Text('Teléfono del Doctor:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    state.homeServiceConfirmed.phoneNumberDoctor,
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const SizedBox(width: 20.0),
                                  const Text('Tipo de Servicio:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    state.homeServiceConfirmed.typeService,
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 20.0),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            elevation: 5,
                                            side: const BorderSide(
                                                width: 2,
                                                color: Color(0xffFFFFFF)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        onPressed: () {
                                          BlocProvider.of<MainBloc>(context).add(
                                              CompleteAmdEvent(state
                                                  .homeServiceConfirmed
                                                  .idHomeService));
                                        },
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xffF96352),
                                                    Color(0xffD84835)
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            child: const Text(
                                              'Finalizar AMD',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Color(0xffFFFFFF),
                                                  fontFamily: 'TitlesHighlight',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            elevation: 5,
                                            side: const BorderSide(
                                                width: 2,
                                                color: Color(0xffFFFFFF)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        onPressed: () {
                                          _launchURL(
                                              url: state
                                                  .homeServiceConfirmed.linkAmd);
                                        },
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xff2B5178),
                                                    Color(0xff273456)
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            child: const Text(
                                              'Formulario AMD',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Color(0xffFFFFFF),
                                                  fontFamily: 'TitlesHighlight',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.only(right: 20.0),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(70))),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                      child: Image.asset(
                                    'assets/images/gps_doctor_image.png',
                                    width: 240,
                                    height: 240,
                                  )),
                                  const Text(
                                    'No tienes atención médica confirmada en estos momentos',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'TitlesHighlight',
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL({required String url}) async {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
