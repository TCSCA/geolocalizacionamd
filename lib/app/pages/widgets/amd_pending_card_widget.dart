import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/core/models/home_service_model.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/constants/app_constants.dart';
import 'package:geolocalizacionamd/app/pages/routes/geoamd_route.dart';
import 'package:geolocalizacionamd/app/pages/sources/main/bloc/main_bloc.dart';
import 'package:geolocalizacionamd/app/shared/dialog/custom_dialog_box.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AmdPendingCard extends StatelessWidget {
  final HomeServiceModel homeService;
  const AmdPendingCard({super.key, required this.homeService});

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
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10.0),
              ListTile(
                leading: Image.asset('assets/images/gps_doctor_image.png'),
                title: Text('Orden Nro. ${homeService.orderNumber}'),
                subtitle: Column(
                  children: [
                    const SizedBox(height: 3.0),
                    Row(
                      children: const [
                        Text('Paciente:',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(homeService.fullNamePatient),
                        )
                      ],
                    ),
                    const SizedBox(height: 3.0),
                    Row(
                      children: [
                        const Text('Teléfono:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Flexible(child: Text(homeService.phoneNumberPatient))
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Dirección del paciente:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(homeService.address),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                  title: context.appLocalization.titleWarning,
                                  descriptions:
                                      '¿Estas seguro de rechazar la orden?',
                                  isConfirmation: true,
                                  dialogAction: () =>
                                      BlocProvider.of<MainBloc>(context).add(
                                          DisallowAmdEvent(
                                              homeService.idHomeService)),
                                  type: AppConstants.statusWarning,
                                  isdialogCancel: false,
                                  dialogCancel: () {});
                            });
                      },
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
                  const SizedBox(width: 25.0),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                  title: context.appLocalization.titleWarning,
                                  descriptions:
                                      '¿Estas seguro de confirmar la orden?',
                                  isConfirmation: true,
                                  dialogAction: () =>
                                      BlocProvider.of<MainBloc>(context).add(
                                          ConfirmAmdEvent(
                                              homeService.idHomeService)),
                                  type: AppConstants.statusWarning,
                                  isdialogCancel: false,
                                  dialogCancel: () {});
                            });
                      },
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
