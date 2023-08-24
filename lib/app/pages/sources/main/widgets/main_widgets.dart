import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/shared/image_build/bloc/image_profile_bloc.dart';
import 'package:geolocalizacionamd/app/shared/image_build/image_widget.dart';
import 'package:go_router/go_router.dart';
import '/app/extensions/localization_ext.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/main/bloc/main_bloc.dart';
import '/app/pages/widgets/amd_pending_card_empty_widget.dart';
import '/app/pages/widgets/amd_pending_card_widget.dart';
import '/app/shared/dialog/custom_dialog_box.dart';
import '/app/shared/loading/loading_builder.dart';
import '/app/pages/sources/login/bloc/login_bloc.dart';
import '/app/pages/widgets/common_widgets.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/core/models/select_model.dart';
import '/app/pages/styles/app_styles.dart';

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
          final user = BlocProvider.of<LoginBloc>(context).user;
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
                      radius: 55,
                      child: BlocBuilder<ImageProfileBloc, ImageProfileState>(
                        builder: (context, state) {
                          return ImageWidget(
                                  onClicked: () {},
                                  isEdit: false,
                                  imagePath: state is InitialImageProfileState
                                      ? state.imageBuild
                                      : null,
                                  color: Colors
                                      .blueGrey) /*CircleAvatar(
                            backgroundImage: Image.memory(
                                    Uint8List.fromList(user.photoPerfil))
                                .image,
                            radius: 55,
                          )*/
                              ;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bienvenido(a)',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 18.0)),
                      Text(user.name,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20.0))
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
}

class ServiceAvailabilityDashboard extends StatelessWidget {
  const ServiceAvailabilityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MainBloc>(context).add(const CheckDoctorConnectedEvent());
    bool doctorAvailableSwitch =
        BlocProvider.of<MainBloc>(context).doctorAvailableSwitch;
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is MainInitial) {
          LoadingBuilder(context).hideOpenDialog();
          doctorAvailableSwitch = state.doctorAvailable;
        }
        if (state is DoctorServiceState) {
          //desactivarservicio
          LoadingBuilder(context).hideOpenDialog();
          doctorAvailableSwitch = state.doctorAvailable;
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
        if (state is DoctorServiceErrorState) {
          //desactivarservicio
          LoadingBuilder(context).hideOpenDialog();
          doctorAvailableSwitch = state.doctorAvailable;
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
        if (state is ConfirmHomeServiceSuccessState) {
          LoadingBuilder(context).hideOpenDialog();
          doctorAvailableSwitch = false;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages()
                      .getMessageTitle(context, AppConstants.statusSuccess),
                  descriptions: AppMessages()
                      .getMessage(context, context.appLocalization.appMsg010),
                  isConfirmation: false,
                  dialogAction: () {},
                  type: AppConstants.statusSuccess,
                  isdialogCancel: false,
                  dialogCancel: () {},
                );
              });
        }
        if (state is DisallowHomeServiceSuccessState) {
          doctorAvailableSwitch = false;
        }
        if (state is HomeServiceSuccessState) {
          doctorAvailableSwitch = false;
        }
        if (state is ShowAmdOrderAdminFinalizedState) {
          LoadingBuilder(context).hideOpenDialog();
          doctorAvailableSwitch = false;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages()
                      .getMessageTitle(context, AppConstants.statusWarning),
                  descriptions:
                      AppMessages().getMessage(context, state.message),
                  isConfirmation: false,
                  dialogAction: () {},
                  type: AppConstants.statusWarning,
                  isdialogCancel: false,
                  dialogCancel: () {},
                );
              });
        }
        if (state is DoctorHomeServiceAssignedState) {
          //LoadingBuilder(context).hideOpenDialog();
          showDialog(
              context: context,
              barrierDismissible: false,
              routeSettings: const RouteSettings(name: GeoAmdRoutes.home),
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages()
                      .getMessageTitle(context, AppConstants.statusWarning),
                  descriptions:
                      AppMessages().getMessage(context, state.message),
                  isConfirmation: false,
                  dialogAction: () {},
                  type: AppConstants.statusWarning,
                  isdialogCancel: false,
                  dialogCancel: () {},
                );
              }).then((value) {
            context.go(GeoAmdRoutes.home);
          });
        }
        if (state is DoctorHomeServiceAttentionState) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages()
                      .getMessageTitle(context, AppConstants.statusWarning),
                  descriptions:
                      AppMessages().getMessage(context, state.message),
                  isConfirmation: false,
                  dialogAction: () {},
                  type: AppConstants.statusWarning,
                  isdialogCancel: false,
                  dialogCancel: () {},
                );
              }).then((value) {
            AppCommonWidgets.pageCurrentChanged(
                context: context, routeParam: GeoAmdRoutes.medicalCareAccepted);
          });
        }
        if (state is NotHomeServiceAssignedState) {
          context.go(GeoAmdRoutes.amdLocation);
        }
      },
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 255,
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
                Text(
                  'Ten presente:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Nuestros pacientes deben recibir un trato digno y respetuoso en cualquier momento y bajo cualquier circunstancia.',
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text('Disponible para atender:',
                            style: Theme.of(context).textTheme.labelLarge),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (doctorAvailableSwitch) ...[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 5.0,
                            side: const BorderSide(
                                width: 2, color: Color(0xffFFFFFF)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                    title: context.appLocalization.titleWarning,
                                    descriptions:
                                        '¿Estás seguro de desactivar su servicio?',
                                    isConfirmation: true,
                                    dialogAction: () =>
                                        BlocProvider.of<MainBloc>(context)
                                            .add(DisconectDoctorAmdEvent()),
                                    type: AppConstants.statusWarning,
                                    isdialogCancel: false,
                                    dialogCancel: () {});
                              });
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            child: Row(
                              children: [
                                const Icon(Icons.person_pin_circle,
                                    size: 24.0, color: Colors.white),
                                //const SizedBox(width: 5.0),
                                Text(
                                  "Disponible",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ] else ...[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 5.0,
                            side: const BorderSide(
                                width: 2, color: Color(0xffFFFFFF)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: () => BlocProvider.of<MainBloc>(context)
                            .add(const ValidateDoctorAmdAssignedEvent()),
                        child: Ink(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                            child: Row(
                              children: [
                                const Icon(Icons.power_settings_new,
                                    size: 24.0, color: Colors.white),
                                const SizedBox(width: 5.0),
                                Text(
                                  "No disponible",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ]
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class AmdInformationAssigned extends StatelessWidget {
  const AmdInformationAssigned({super.key});

  @override
  Widget build(BuildContext context) {
    MainBloc userMainBloc = BlocProvider.of<MainBloc>(context);
    userMainBloc.add(const ShowHomeServiceAssignedEvent());
    final GlobalKey<FormState> reasonRejectionFormKey = GlobalKey<FormState>();
    final GlobalKey<FormFieldState> reasonFieldKey =
        GlobalKey<FormFieldState>();
    final TextEditingController reasonTextController = TextEditingController();
    // ignore: unused_local_variable
    bool doctorAvailableSwitch = userMainBloc.doctorAvailableSwitch;
    return SingleChildScrollView(
      //padding: const EdgeInsets.all(10.0),
      child: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {
          if (state is MainShowLoadingState) {
            LoadingBuilder(context).showLoadingIndicator(state.message);
          }
          if (state is HomeServicePendingFinishState) {
            //atencion pendiente por finalizar
            doctorAvailableSwitch = false;
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: AppMessages()
                        .getMessageTitle(context, AppConstants.statusWarning),
                    descriptions:
                        AppMessages().getMessage(context, state.message),
                    isConfirmation: false,
                    dialogAction: () {},
                    type: AppConstants.statusWarning,
                    isdialogCancel: false,
                    dialogCancel: () {},
                  );
                });
          }
          if (state is DisallowHomeServiceSuccessState) {
            LoadingBuilder(context).hideOpenDialog();
            doctorAvailableSwitch = false;
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
            LoadingBuilder(context).hideOpenDialog();
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
          if (state is HomeServiceAssignedErrorState) {
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
          if (state is ReasonRejectionSuccessState) {
            LoadingBuilder(context).hideOpenDialog();
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        side: BorderSide(
                          color: AppStyles.colorBeige,
                          style: BorderStyle.solid,
                          width: 4.0,
                        ),
                      ),
                      content: Stack(
                        children: <Widget>[
                          Form(
                            key: reasonRejectionFormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Seleccione el motivo de rechazo y pulse Aceptar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppStyles.colorBluePrimary,
                                          fontFamily: 'TextsParagraphs',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        isDense: true,
                                        itemHeight: null,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0)),
                                        hint:
                                            const Text("Seleccione una opción"),
                                        key: reasonFieldKey,
                                        decoration: InputDecoration(
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppStyles
                                                      .colorBluePrimary)),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: AppStyles
                                                      .colorBluePrimary)),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                              vertical: 18),
                                          labelText: 'Motivo:',
                                          hintText: 'Seleccione una opción',
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 22.0),
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: Colors.black),
                                        items: state.listReasonRejection
                                            .map((SelectModel selectiveReason) {
                                          return DropdownMenuItem(
                                            value: selectiveReason.id,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                selectiveReason.name,
                                                overflow: TextOverflow.visible,
                                                softWrap: true,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (fieldValue) {
                                          if (fieldValue == null) {
                                            return 'Campo requerido.';
                                          }
                                          return null;
                                        },
                                        onChanged: (reasonCode) {
                                          if (reasonCode != null) {
                                            reasonTextController.text =
                                                reasonCode;
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
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
                                        if (!reasonRejectionFormKey
                                            .currentState!
                                            .validate()) {
                                          return;
                                        } else {
                                          context.pop();
                                          BlocProvider.of<MainBloc>(context)
                                              .add(DisallowAmdEvent(
                                                  state.homeServiceAssigned
                                                      .idHomeService,
                                                  reasonTextController.text));
                                        }
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
                                              vertical: 10, horizontal: 20),
                                          child: Text(
                                            'Aceptar',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          if (state is ShowAmdOrderAdminFinalizedState) {
            LoadingBuilder(context).hideOpenDialog();
            doctorAvailableSwitch = false;
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: AppMessages()
                        .getMessageTitle(context, AppConstants.statusWarning),
                    descriptions:
                        AppMessages().getMessage(context, state.message),
                    isConfirmation: false,
                    dialogAction: () {},
                    type: AppConstants.statusWarning,
                    isdialogCancel: false,
                    dialogCancel: () {},
                  );
                });
          }
          if (state is AmdConfirmedAdminSuccessState) {
            LoadingBuilder(context).hideOpenDialog();
            //Viene del boton Ver atencion y se redicciona a pagina En Atencion
            AppCommonWidgets.pageCurrentChanged(
                context: context, routeParam: GeoAmdRoutes.medicalCareAccepted);
          }
        },
        /* buildWhen: (previous, current) =>
            previous != current && current is HomeServiceSuccessState, */
        builder: (context, state) {
          if (state is HomeServiceSuccessState) {
            //LoadingBuilder(context).hideOpenDialog();
            final homeServiceAssigned = (state).homeServiceAssigned;
            return AmdPendingCard(homeService: homeServiceAssigned);
          } else if (state is ReasonRejectionSuccessState) {
            //LoadingBuilder(context).hideOpenDialog();
            final homeServiceAssigned = (state.homeServiceAssigned);
            return AmdPendingCard(homeService: homeServiceAssigned);
          } else if (state is DoctorHomeServiceAssignedState) {
            //LoadingBuilder(context).hideOpenDialog();
            final homeServiceAssigned =
                BlocProvider.of<MainBloc>(context).homeServicePending;
            return AmdPendingCard(homeService: homeServiceAssigned);
          } else {
            //LoadingBuilder(context).hideOpenDialog();
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
