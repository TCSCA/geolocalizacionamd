import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:geolocalizacionamd/app/core/controllers/amd_pending_controller.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_pending/bloc/amd_pending_bloc.dart';

import '../../../shared/dialog/custom_dialog_box.dart';
import '../../../shared/loading/loading_builder.dart';
import '../../constants/app_constants.dart';
import '../../messages/app_messages.dart';

class AmdPendingPage extends StatefulWidget {
  const AmdPendingPage({super.key});

  @override
  State<AmdPendingPage> createState() => _AmdPendingPageState();
}

class _AmdPendingPageState extends State<AmdPendingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AmdPendingBloc(amdPendingController: AmdPendingController())
            ..add(ConsultDataAmdPendingEvent()),
      child: const _AmdPendingView(),
    );
  }
}

class _AmdPendingView extends StatelessWidget {
  const _AmdPendingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
           backgroundColor: Colors.white,
          ),*/
      // backgroundColor: Colors.red,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Image.asset(
                  'assets/images/telemedicina24_logo_azul_lineal.png',
                  width: 270,
                  height: 90,
                ),
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      size: 35.0,
                    ))
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        )
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  child: BlocConsumer<AmdPendingBloc, AmdPendingState>(
                    listener: (context, state) {
                      if(state is IsNotAmdPendingState) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: AppMessages()
                                    .getMessageTitle(context, AppConstants.statusWarning),
                                descriptions:
                                AppMessages().getMessage(context, 'No tiene un AMD pendiente'),
                                isConfirmation: false,
                                dialogAction: () {},
                                type: AppConstants.statusError,
                              );
                            });
                      }
                    },
                    builder: (context, state) {
                      if (state is IsAmdPendingState) {
                        return ListView(
                          children: [
                            _AmdPendingInfo(
                                title: 'Fecha',
                                subtitle: state.amdPendingModel.orderTime),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'Numero de orden',
                                subtitle: '${state.amdPendingModel.orderId}'),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'Nombre del paciente',
                                subtitle: state.amdPendingModel.patientName),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'Cedula',
                                subtitle:
                                    state.amdPendingModel.idDocumentationPatient),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'Numero de telefono',
                                subtitle: state.amdPendingModel.phonePatient),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'Estado',
                                subtitle: state.amdPendingModel.state),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'Ciudad',
                                subtitle: state.amdPendingModel.city),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'direccion',
                                subtitle: state.amdPendingModel.direction),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'Nombre del doctor',
                                subtitle: state.amdPendingModel.doctorName),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'Telefono del doctor',
                                subtitle: state.amdPendingModel.phoneDoctor),
                            const Divider(
                              height: 1,
                            ),
                            _AmdPendingInfo(
                                title: 'Tipo de servicio',
                                subtitle: state.amdPendingModel.serviceType),
                          ],
                        );
                      } else if(state is IsLoadingAmdPendingState){
                        LoadingBuilder(context).showLoadingIndicator(
                            context.appLocalization.titleLoginLoading);
                        return Container();
                      } else if(state is IsNotAmdPendingState){
                          return Container();
                      }
                      else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmdPendingInfo extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AmdPendingInfo(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
