import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/core/models/select_model.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/messages/app_messages.dart';
import 'package:geolocalizacionamd/app/pages/routes/geoamd_route.dart';
import 'package:geolocalizacionamd/app/pages/sources/main/bloc/main_bloc.dart';
import 'package:geolocalizacionamd/app/pages/widgets/amd_pending_card_empty_widget.dart';
import 'package:geolocalizacionamd/app/pages/widgets/amd_pending_card_widget.dart';
import 'package:geolocalizacionamd/app/shared/dialog/custom_dialog_box.dart';
import 'package:geolocalizacionamd/app/shared/loading/loading_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '/app/pages/sources/login/bloc/login_bloc.dart';
import '/app/pages/widgets/common_widgets.dart';
import '/app/pages/constants/app_constants.dart';

class MainWidgets {
  PreferredSizeWidget generateAppBar({required BuildContext context}) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: const Color(0xFFfbfcff),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Image.asset(
                AppConstants.logoImageBlue,
                width: 270,
                height: 90,
              )),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      //isDismissible: false,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: AppCommonWidgets.generateMenuInfo(
                                context: context),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 35.0,
                    color: Colors.black,
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget createDoctorInfo({required BuildContext context}) {
    return Container(
      color: const Color(0xFFfbfcff),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 7,
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) =>
            previous != current && current is LoginSuccessState,
        builder: (context, state) {
          final user = (state as LoginSuccessState).user;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xff2B5178),
                    radius: 70,
                    child: CircleAvatar(
                      backgroundColor: const Color(0xff2B5178),
                      radius: 90,
                      child: CircleAvatar(
                        backgroundImage:
                            Image.memory(Uint8List.fromList(user.photoPerfil))
                                .image,
                        radius: 55,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bienvenido(a)',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      Text(user.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))
                    ],
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget serviceAvailabilityDashboard({required BuildContext context}) {
    bool isServiceAvailible = false;
    /* MainBloc userMainBloc = BlocProvider.of<MainBloc>(context);
    userMainBloc.add(const ShowLocationDoctorStatesEvent('25'));
    List<SelectModel> stateList = [];
    String? selectedState;
    List<SelectModel> cityList = []; */
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 220,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
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
        padding: const EdgeInsets.only(left: 20.0, top: 25.0, right: 20.0),
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
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Row(
                  children: const [
                    Text('Disponible para atender:',
                        style: TextStyle(fontSize: 18.0, color: Colors.white)),
                  ],
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xff273456),
                            blurRadius: 10.0,
                            offset: Offset(4.0, 5.0))
                      ]),
                  child: BlocConsumer<MainBloc, MainState>(
                      listener: (context, state) {
                    if (state is DoctorServiceState) {
                      isServiceAvailible = state.doctorAvailable;
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
                    if (state is DoctorServiceErrorState) {
                      isServiceAvailible = state.doctorAvailable;
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
                    if (state is CancelButtonAmdState) {
                      isServiceAvailible = state.doctorAvailable;
                    }
                    /* if (state is LocationStatesSuccessState) {
                      stateList = state.listStates;
                    }
                    if (state is LocationCitiesSuccessState) {
                      cityList = state.listCities;
                      selectedState = state.selectedState;
                    } */
                  }, builder: (context, state) {
                    return LiteRollingSwitch(
                        width: 90.0,
                        value: BlocProvider.of<MainBloc>(context)
                            .doctorAvailableSwitch,
                        textOn: 'SI',
                        textOff: 'NO',
                        colorOn: Colors.green,
                        colorOff: Colors.grey,
                        textOffColor: Colors.white,
                        textOnColor: Colors.white,
                        iconOn: Icons.person_pin_circle,
                        iconOff: Icons.power_settings_new,
                        onChanged: (isServiceAvailible) {
                          print('onChanged ${(isServiceAvailible)}');
                          print(
                              'onChanged turned ${(isServiceAvailible) ? 'encendido' : 'apagado'}');
                          if (!isServiceAvailible) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                      title:
                                          context.appLocalization.titleWarning,
                                      descriptions:
                                          '¿Estas seguro de desactivar su servicios?',
                                      isConfirmation: true,
                                      dialogAction: () =>
                                          BlocProvider.of<MainBloc>(context)
                                              .add(DisconectDoctorAmdEvent()),
                                      type: AppConstants.statusWarning,
                                      isdialogCancel: true,
                                      dialogCancel: () =>
                                          BlocProvider.of<MainBloc>(context)
                                              .add(CancelButtonAmdEvent(
                                                  currentToggleSwitch:
                                                      isServiceAvailible)));
                                });
                          } else {
                            /* showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                    title: context.appLocalization.titleWarning,
                                    descriptions:
                                        '¿Estas seguro de activar su servicios?',
                                    isConfirmation: true,
                                    dialogAction: () =>
                                        BlocProvider.of<MainBloc>(context)
                                            .add(ConnectDoctorAmdEvent()),
                                    type: AppConstants.statusWarning,
                                    isdialogCancel: true,
                                    dialogCancel: () =>
                                        BlocProvider.of<MainBloc>(context).add(
                                            CancelButtonAmdEvent(
                                                currentToggleSwitch:
                                                    isServiceAvailible)),
                                  );
                                }); */
                            /* showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  final GlobalKey<FormState> ubicacionFormKey =
                                      GlobalKey<FormState>();
                                  final GlobalKey<FormFieldState>
                                      estadoFieldKey =
                                      GlobalKey<FormFieldState>();
                                  final GlobalKey<FormFieldState>
                                      ciudadFieldKey =
                                      GlobalKey<FormFieldState>();
                                  return AlertDialog(
                                    title:
                                        const Text('Seleccione su Ubicación:'),
                                    content: Form(
                                      key: ubicacionFormKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: DropdownButtonFormField(
                                                  key: estadoFieldKey,
                                                  value: selectedState,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Seleccione',
                                                    labelText: 'Estado:',
                                                  ),
                                                  items: stateList.map(
                                                      (SelectModel
                                                          selectiveCountry) {
                                                    return DropdownMenuItem(
                                                      value:
                                                          selectiveCountry.id,
                                                      child: Text(
                                                          selectiveCountry
                                                              .name),
                                                    );
                                                  }).toList(),
                                                  validator: (fieldValue) {
                                                    if (fieldValue == null) {
                                                      return 'Es requerido';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (stateCode) {
                                                    if (stateCode != null) {
                                                      userMainBloc.add(
                                                          ShowLocationDoctorCitiesEvent(
                                                              stateCode));
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: DropdownButtonFormField(
                                                  key: ciudadFieldKey,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Ciudad:',
                                                    hintText: 'Seleccione',
                                                  ),
                                                  items: cityList.map(
                                                      (SelectModel
                                                          selectiveCountry) {
                                                    return DropdownMenuItem(
                                                      value:
                                                          selectiveCountry.id,
                                                      child: Text(
                                                          selectiveCountry
                                                              .name),
                                                    );
                                                  }).toList(),
                                                  validator: (fieldValue) {
                                                    if (fieldValue == null) {
                                                      return 'Es requerido';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (!ubicacionFormKey.currentState!
                                              .validate()) {
                                            return;
                                          } else {}
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Send'),
                                      ),
                                    ],
                                  );
                                }); */
                            context.go(GeoAmdRoutes.amdLocation);
                          }
                        },
                        onTap: () {},
                        onDoubleTap: () {},
                        onSwipe: () {});
                  }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget amdInformationAssigned({required BuildContext context}) {
    MainBloc userMainBloc = BlocProvider.of<MainBloc>(context);
    userMainBloc.add(const ShowHomeServiceAssignedEvent());
    return SingleChildScrollView(
      //padding: const EdgeInsets.all(10.0),
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {
          if (state is MainShowLoadingState) {
            LoadingBuilder(context)
                .showLoadingIndicator('Procesando su solicitud');
          }
          /* if (state is ConfirmHomeServiceSuccessState) {
            //LoadingBuilder(context).hideOpenDialog();
            context.go(GeoAmdRoutes.medicalCareAccepted);
          } */
          if (state is DisallowHomeServiceSuccessState) {
            //LoadingBuilder(context).hideOpenDialog();
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: AppMessages()
                        .getMessageTitle(context, AppConstants.statusSuccess),
                    descriptions:
                        AppMessages().getMessage(context, state.message),
                    isConfirmation: false,
                    dialogAction: () {},
                    type: AppConstants.statusSuccess,
                    isdialogCancel: false,
                    dialogCancel: () {},
                  );
                });
          }
          if (state is HomeServiceErrorState) {
            //LoadingBuilder(context).hideOpenDialog();
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: AppMessages()
                        .getMessageTitle(context, AppConstants.statusError),
                    descriptions:
                        AppMessages().getMessage(context, state.message),
                    isConfirmation: false,
                    dialogAction: () {},
                    type: AppConstants.statusError,
                    isdialogCancel: false,
                    dialogCancel: () {},
                  );
                });
          }
        },
        /* buildWhen: (previous, current) =>
            previous != current && current is HomeServiceSuccessState, */
        builder: (context, state) {
          //LoadingBuilder(context).hideOpenDialog();
          if (state is HomeServiceSuccessState) {
            final homeServiceAssigned = (state).homeServiceAssigned;
            return AmdPendingCard(homeService: homeServiceAssigned);
          } else {
            return AmdPendingCardEmpty(
                title: 'Sin Orden para atender',
                message: AppMessages()
                    .getMessage(context, AppConstants.codeDoctorInAttention));
          }
        },
      ),
    );
  }
}
