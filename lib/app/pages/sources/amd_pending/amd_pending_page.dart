import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/amd_history/widgets/bloc/amd_form_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '/app/shared/method/back_button_action.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/sources/main/bloc/main_bloc.dart';
import '/app/pages/widgets/common_widgets.dart';
import '/app/shared/dialog/custom_dialog_box.dart';
import '/app/extensions/localization_ext.dart';
import '/app/core/models/select_model.dart';
import '/app/pages/styles/app_styles.dart';
import '/app/core/models/home_service_model.dart';
import '/app/shared/dialog/custom_dialog_sino.dart';
import '/app/shared/loading/loading_builder.dart';
import '/app/pages/routes/geoamd_route.dart';

class AmdPendingPage extends StatefulWidget {
  const AmdPendingPage({super.key});

  @override
  State<AmdPendingPage> createState() => _AmdPendingPageState();
}

class _AmdPendingPageState extends State<AmdPendingPage> {
  final GlobalKey<FormState> reasonCompleteFormKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> reasonFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController reasonTextController = TextEditingController();

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
            child: BlocProvider(
              create: (context) => AmdFormBloc(),
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
                        padding: const EdgeInsets.only(right: 0.0),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.only(topRight: Radius.circular(70))),
                        child: BlocConsumer<MainBloc, MainState>(
                          listener: (context, state) {
                            if (state is ShowLoadingInAttentionState) {
                              LoadingBuilder(context)
                                  .showLoadingIndicator(state.message);
                            }
                            if (state is ConfirmHomeServiceSuccessState) {
                              LoadingBuilder(context).hideOpenDialog();
                            }
                            /* if (state is HomeServiceInAttentionState) {
                            LoadingBuilder(context).hideOpenDialog();
                          } */
                            if (state is ReasonCompleteSuccessState) {
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
                                              key: reasonCompleteFormKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  const Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Indica cuál fue el motivo:',
                                                          textAlign:
                                                          TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: AppStyles
                                                                  .colorBluePrimary,
                                                              fontFamily:
                                                              'TextsParagraphs'
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                        DropdownButtonFormField(
                                                          isExpanded: true,
                                                          isDense: true,
                                                          itemHeight: null,
                                                          borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8.0)),
                                                          hint: const Text(
                                                              "Seleccione una opción"),
                                                          key: reasonFieldKey,
                                                          decoration:
                                                          InputDecoration(
                                                            focusedBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: AppStyles
                                                                        .colorBluePrimary)),
                                                            enabledBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: AppStyles
                                                                        .colorBluePrimary)),
                                                            contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical:
                                                                18),
                                                            labelText: 'Motivo:',
                                                            hintText:
                                                            'Seleccione una opción',
                                                            labelStyle: Theme
                                                                .of(
                                                                context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.copyWith(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                22.0),
                                                          ),
                                                          style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .labelLarge
                                                              ?.copyWith(
                                                              color: Colors
                                                                  .black),
                                                          items: state
                                                              .listReasonComplete
                                                              .map((SelectModel
                                                          selectiveReason) {
                                                            return DropdownMenuItem(
                                                              value:
                                                              selectiveReason
                                                                  .id,
                                                              child: SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Text(
                                                                  selectiveReason
                                                                      .name,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                                  softWrap: true,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                          validator:
                                                              (fieldValue) {
                                                            if (fieldValue ==
                                                                null) {
                                                              return 'Campo requerido.';
                                                            }
                                                            return null;
                                                          },
                                                          onChanged:
                                                              (reasonCode) {
                                                            if (reasonCode !=
                                                                null) {
                                                              reasonTextController
                                                                  .text =
                                                                  reasonCode;
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20.0),
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                            padding:
                                                            EdgeInsets.zero,
                                                            elevation: 5,
                                                            side: const BorderSide(
                                                                width: 2,
                                                                color: Color(
                                                                    0xffFFFFFF)),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    30))),
                                                        onPressed: () {
                                                          if (!reasonCompleteFormKey
                                                              .currentState!
                                                              .validate()) {
                                                            return;
                                                          } else {
                                                            context.pop();
                                                            BlocProvider.of<
                                                                MainBloc>(
                                                                context)
                                                                .add(
                                                                CompleteAmdEvent(
                                                                    state
                                                                        .homeServiceAssigned
                                                                        .idHomeService,
                                                                    reasonTextController
                                                                        .text));
                                                          }
                                                        },
                                                        child: Ink(
                                                          decoration: BoxDecoration(
                                                              gradient:
                                                              const LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                        0xffF96352),
                                                                    Color(
                                                                        0xffD84835)
                                                                  ]),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  30)),
                                                          child: Container(
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10,
                                                                horizontal:
                                                                20),
                                                            child: Text(
                                                              'Aceptar',
                                                              textAlign: TextAlign
                                                                  .center,
                                                              style: Theme
                                                                  .of(
                                                                  context)
                                                                  .textTheme
                                                                  .labelLarge
                                                                  ?.copyWith(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                            if (state is CompleteHomeServiceSuccessState) {
                              LoadingBuilder(context).hideOpenDialog();
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
                              LoadingBuilder(context).hideOpenDialog();
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
                            if (state is AmdOrderAdminSuccessState) {
                              LoadingBuilder(context).hideOpenDialog();
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CustomDialogSino(
                                        title:
                                        context.appLocalization.titleWarning,
                                        descriptions:
                                        '¿La atención finalizó exitosamente?',
                                        dialogAction: () =>
                                            BlocProvider.of<MainBloc>(context)
                                                .add(CompleteAmdEvent(
                                                state.homeServiceAssigned
                                                    .idHomeService,
                                                AppConstants
                                                    .idCompleteAmdSuccess)),
                                        type: AppConstants.statusWarning,
                                        dialogCancel: () =>
                                            BlocProvider.of<
                                                MainBloc>(context)
                                                .add(
                                                ShowReasonCompleteStatesEvent(
                                                    state
                                                        .homeServiceAssigned)));
                                  });
                            }
                            if (state is ShowAmdOrderAdminFinalizedState) {
                              LoadingBuilder(context).hideOpenDialog();
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                      title: AppMessages().getMessageTitle(
                                          context, AppConstants.statusWarning),
                                      descriptions: AppMessages()
                                          .getMessage(context, state.message),
                                      isConfirmation: false,
                                      dialogAction: () {},
                                      type: AppConstants.statusWarning,
                                      isdialogCancel: false,
                                      dialogCancel: () {},
                                    );
                                  });
                            }
                          },
                          /*buildWhen: (previous, current) =>
                            previous != current &&
                            (current is ConfirmHomeServiceSuccessState),*/
                          builder: (context, state) {
                            if (state is ConfirmHomeServiceSuccessState) {
                              return showDataAmd(
                                  state.homeServiceConfirmed, context);
                            } else if (state is ReasonCompleteSuccessState) {
                              return showDataAmd(
                                  state.homeServiceAssigned, context);
                            } else if (state is AmdOrderAdminSuccessState) {
                              return showDataAmd(
                                  state.homeServiceAssigned, context);
                            } else
                            if (state is ShowHomeServiceInAttentionState) {
                              return showDataAmd(
                                  state.homeServiceConfirmed, context);
                            } else {
                              //LoadingBuilder(context).hideOpenDialog();
                              return Container(
                                padding: const EdgeInsets.only(right: 0.0),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(70))),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                          child: Image.asset(
                                            'assets/images/gps_doctor_image.png',
                                            width: 300,
                                          )),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        'No tienes atención médica confirmada en estos momentos',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 70,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showDataAmd(HomeServiceModel homeServiceConfirmed,
      BuildContext context) {
    return SizedBox(
      height: MediaQuery
          .of(context)
          .size
          .height * 2,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 20.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text(
                  "Datos de Orden Médica:",
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text('Fecha y Hora:',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(
                  DateFormat(AppConstants.dateTimeFormat)
                      .format(homeServiceConfirmed.registerDate),
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.black),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text('Nro. de Orden:',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(
                  homeServiceConfirmed.orderNumber,
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.black),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text(
                  "Datos del Paciente:",
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text('Nombre del Paciente:',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Flexible(
                  child: Text(
                    homeServiceConfirmed.fullNamePatient,
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.black),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text('Documento de identidad:',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(
                  homeServiceConfirmed.identificationDocument,
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.black),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text('Teléfono:',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(
                  homeServiceConfirmed.phoneNumberPatient,
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.black),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20.0),
                Text('Dirección :',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Flexible(
                  child: Text(homeServiceConfirmed.address,
                      style: Theme
                          .of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.black)),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text(
                  "Datos del Doctor:",
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text('Doctor Solicitante:',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Flexible(
                  child: Text(
                    homeServiceConfirmed.applicantDoctor,
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.black),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text('Teléfono del Doctor:',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(
                  homeServiceConfirmed.phoneNumberDoctor,
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.black),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const SizedBox(width: 20.0),
                Text('Tipo de Servicio:',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Text(
                  homeServiceConfirmed.typeService,
                  style: Theme
                      .of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.black),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 5,
                            side: const BorderSide(
                                width: 2, color: Color(0xffFFFFFF)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: () {
                          BlocProvider.of<MainBloc>(context).add(
                              ValidateOrderAmdProcessedAdminEvent(
                                  homeServiceConfirmed));
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [
                                Color(0xffF96352),
                                Color(0xffD84835)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 21),
                            child: Text(
                              'Finalizar AMD',
                              textAlign: TextAlign.center,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )),
                ),
                Flexible(
                  child: BlocListener<AmdFormBloc, AmdFormState>(
                    listener: (context, state) {
                      if(state is AmdFormLoading) {
                        LoadingBuilder(context).showLoadingIndicator('Procesando su solicitud');
                      }
                      if (state is AmdRenewFormSuccessState) {
                        LoadingBuilder(context).hideOpenDialog();
                        launchUrl(
                          Uri.parse(state.urlFormRenew),
                          mode: LaunchMode.externalApplication,
                        );
                        context.go(GeoAmdRoutes.home);
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 5,
                              side: const BorderSide(
                                  width: 2, color: Color(0xffFFFFFF)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () {
                            // homeServiceConfirmed.idMedicalOerder;
                            BlocProvider.of<AmdFormBloc>(context).add(
                                AmdRenewFormEvent(
                                    idMedicalOrder: homeServiceConfirmed
                                        .idMedicalOerder));
                            // _launchURL(url: homeServiceConfirmed.linkAmd);

                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xff2B5178),
                                  Color(0xff273456)
                                ]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Text(
                                'Formulario AMD',
                                textAlign: TextAlign.center,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL({required String url}) async {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    super.dispose();
    reasonTextController.dispose();
  }
}
