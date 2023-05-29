import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/api/mappings/amd_pending_mapping.dart';
import 'package:geolocalizacionamd/app/core/controllers/amd_pending_controller.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_pending/bloc/amd_pending_bloc.dart';

import '../../../errors/error_app_exception.dart';
import '../../../errors/error_general_exception.dart';

class AmdPendingPage extends StatefulWidget {
  const AmdPendingPage({super.key});

  @override
  State<AmdPendingPage> createState() => _AmdPendingPageState();
}

class _AmdPendingPageState extends State<AmdPendingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AmdPendingBloc(amdPendingController: AmdPendingController())..add(OnInitialStateEvent()),
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
        child: ListView(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      )
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: BlocBuilder<AmdPendingBloc, AmdPendingState>(
                  builder: (context, state) {
                    if (state is IsAmdPending) {
                      return Column(
                        //physics: const BouncingScrollPhysics(),
                        children: [
                          _AmdPendingInfo(
                              title: 'Fecha', subtitle: state.orderTime),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(
                              title: 'Numero de orden',
                              subtitle: '${state.orderId}'),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(
                              title: 'Nombre del paciente',
                              subtitle: state.patientName),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(
                              title: 'Cedula',
                              subtitle: state.idDocumentationPatient),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(
                              title: 'Numero de telefono',
                              subtitle: state.phonePatient),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(title: 'Estado', subtitle: state.state),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(title: 'Ciudad', subtitle: state.city),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(
                              title: 'direccion', subtitle: state.direction),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(
                              title: 'Nombre del doctor',
                              subtitle: state.doctorName),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(
                              title: 'Telefono del doctor',
                              subtitle: state.phoneDoctor),
                          const Divider(
                            height: 1,
                          ),
                          _AmdPendingInfo(
                              title: 'Tipo de servicio',
                              subtitle: state.serviceType),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
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
    )

        /*Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(title),
        const Divider(),
        Text(subtitle)
      ],
    )*/
        ;
  }
}
