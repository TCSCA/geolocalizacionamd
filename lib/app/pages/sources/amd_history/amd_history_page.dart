import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:geolocalizacionamd/app/core/controllers/amd_history_controller.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_history/bloc/amd_history_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_history/widgets/expansion_title_widget.dart';
import '../../../shared/dialog/custom_dialog_box.dart';
import '../../../shared/loading/loading_builder.dart';
import '../../../shared/method/back_button_action.dart';
import '../../constants/app_constants.dart';
import '../../messages/app_messages.dart';
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
                create: (context) =>
                    AmdHistoryBloc(amdHistoryController: AmdHistoryController())
                      ..add(GetAmdHistoryEvent()),
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

        if(state is AmdHistoryLoadingState) {
          LoadingBuilder(context).showLoadingIndicator(
              'Cargando historial');
        } else if (state is AmdHistorySuccessDataState) {
          LoadingBuilder(context).hideOpenDialog();

        } if(state is AmdHistoryErrorState) {
          LoadingBuilder(context).hideOpenDialog();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages().getMessageTitle(
                      context, AppConstants.statusError),
                  descriptions:
                  AppMessages().getMessage(context, state.messageError),
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
        if (state is AmdHistorySuccessDataState) {
          return TabBarView(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.homeService.length,
                itemBuilder: (BuildContext context, int index) {
                //   Finalizado
                  if(state.homeService[index].idStatusHomeService == 4) {
                    return ExpansionTitleWidget(
                      orderNumber: state.homeService[index].orderNumber,
                      dateOrderDay:
                      state.homeService[index].registerDate.day,
                      dateOrderMonth:
                      state.homeService[index].registerDate.month,
                      dateOrderYear:
                      state.homeService[index].registerDate.year,
                      fullNamePatient: state.homeService[index].fullNamePatient,
                      identificationDocument:
                      state.homeService[index].identificationDocument,
                      phoneNumberPatient:
                      state.homeService[index].phoneNumberPatient,
                      address: state.homeService[index].address,
                      applicantDoctor: state.homeService[index].applicantDoctor,
                      phoneNumberDoctor:
                      state.homeService[index].phoneNumberDoctor,
                      typeService: state.homeService[index].typeService,
                      linkAmd: state.homeService[index].linkAmd,
                      statusHomeService: state.homeService[index].statusHomeService,

                    );
                  } else {
                    return SizedBox();
                  }
                },
                /*children: [
                  */ /*Card(
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
                           trailing: TextButton(
                                  onPressed: () => {}, child: const Text('Ver')),
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
                         Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextButton(
                                    onPressed: () => {},
                                    child: const Text('Ver Detalle')),
                              ],
                            )
                      ],
                    ),
                  ),
                )*/ /*

                ],*/
              ),
              ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.homeService.length,
                itemBuilder: (BuildContext context, int index) {
                  if(state.homeService[index].idStatusHomeService == 3) {
                    return ExpansionTitleWidget(
                      orderNumber: state.homeService[index].orderNumber,
                      dateOrderDay:
                      state.homeService[index].registerDate.day,
                      dateOrderMonth:
                      state.homeService[index].registerDate.month,
                      dateOrderYear:
                      state.homeService[index].registerDate.year,
                      fullNamePatient: state.homeService[index].fullNamePatient,
                      identificationDocument:
                      state.homeService[index].identificationDocument,
                      phoneNumberPatient:
                      state.homeService[index].phoneNumberPatient,
                      address: state.homeService[index].address,
                      applicantDoctor: state.homeService[index].applicantDoctor,
                      phoneNumberDoctor:
                      state.homeService[index].phoneNumberDoctor,
                      typeService: state.homeService[index].typeService,
                      linkAmd: state.homeService[index].linkAmd,
                    );
                  } else {
                    return SizedBox();
                  }

                },
                /*children: [
                  *//*Card(
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
                )*//*
                  ExpansionTitleWidget()
                ],*/
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
