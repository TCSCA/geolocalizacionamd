import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/shared/loading/loading_builder.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/method/back_button_action.dart';
import '/app/core/models/select_model.dart';
import '/app/extensions/localization_ext.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/main/bloc/main_bloc.dart';
import '/app/shared/dialog/custom_dialog_box.dart';

class AmdLocationPage extends StatefulWidget {
  const AmdLocationPage({super.key});

  @override
  State<AmdLocationPage> createState() => _AmdLocationPageState();
}

class _AmdLocationPageState extends State<AmdLocationPage> {
  final GlobalKey<FormState> ubicacionFormKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> estadoFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> ciudadFieldKey = GlobalKey<FormFieldState>();
  final TextEditingController stateTextController = TextEditingController();
  final TextEditingController cityTextController = TextEditingController();
  List<SelectModel> stateList = [];
  String? selectedState;
  List<SelectModel> cityList = [];
  String? selectedCity;
  @override
  Widget build(BuildContext context) {
    MainBloc userMainBloc = BlocProvider.of<MainBloc>(context);
    userMainBloc
        .add(const ShowLocationDoctorStatesEvent(AppConstants.idCountryVzla));
    return WillPopScope(
      onWillPop: () => backButtonActions(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xff2B5178),
            /* leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 20.0,
              onPressed: () {
                context.go('/home');
              },
            ), */
            toolbarHeight: 140.0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //const SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Image.asset(
                      'assets/images/telemedicina24_logo_blanco_lineal.png',
                      width: 270,
                      height: 90,
                    )),
                    /* IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            //isDismissible: false,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
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
                          color: Colors.white,
                        )) */
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Row(
                  children: [
                    Icon(Icons.person_pin_circle, color: Colors.white),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Ubicación de Servicio',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ],
                )
              ],
            )),
        body: BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            if (state is LocationShowLoadingState) {
              LoadingBuilder(context).showLoadingIndicator(state.message);
            }
            if (state is LocationStatesSuccessState) {
              LoadingBuilder(context).hideOpenDialog();
              stateList = state.listStates;
              //selectedState = null;
            }
            if (state is LocationCitiesSuccessState) {
              LoadingBuilder(context).hideOpenDialog();
              cityList = state.listCities;
              selectedState = state.selectedState;
              selectedCity = null;
            }
            if (state is ChangeLocationDoctorCityState) {
              selectedCity = state.selectedCity;
            }
            if (state is LocationErrorState) {
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
            if (state is DoctorServiceState) {
              LoadingBuilder(context).hideOpenDialog();
              //isServiceAvailible = state.doctorAvailable;
              /* showDialog(
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
                  }); */
              context.go(GeoAmdRoutes.home, extra: DoctorServiceState);
            }
            if (state is DoctorServiceErrorState) {
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
          },
          builder: (context, state) {
            return Form(
              key: ubicacionFormKey,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Flexible(
                            child: Text(
                          'Para continuar necesitamos conocer la ubicación de su dispositivo móvil y donde prestará el servicio',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 19.0,
                              color: Colors.black,
                              fontFamily: 'TitlesHighlight',
                              fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            hint: const Text("Seleccione su estado"),
                            key: estadoFieldKey,
                            value: selectedState,
                            decoration: const InputDecoration(
                                hintText: 'Seleccione su estado',
                                labelText: 'Estado:',
                                labelStyle: TextStyle(
                                    fontSize: 27.0,
                                    color: Colors.black,
                                    fontFamily: 'TitlesHighlight')),
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontFamily: 'TextsParagraphs'),
                            items: stateList.map((SelectModel selectiveState) {
                              return DropdownMenuItem(
                                value: selectiveState.id,
                                child: Text(selectiveState.name),
                              );
                            }).toList(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (fieldValue) {
                              if (fieldValue == null) {
                                return 'Estado es requerido';
                              }
                              return null;
                            },
                            onChanged: (stateCode) {
                              if (stateCode != null) {
                                stateTextController.text = stateCode;
                                userMainBloc.add(
                                    ShowLocationDoctorCitiesEvent(stateCode));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField(
                            hint: const Text("Seleccione su ciudad"),
                            key: ciudadFieldKey,
                            value: selectedCity,
                            decoration: const InputDecoration(
                              labelText: 'Ciudad:',
                              hintText: 'Seleccione su ciudad',
                              labelStyle: TextStyle(
                                  fontSize: 27.0,
                                  color: Colors.black,
                                  fontFamily: 'TitlesHighlight'),
                            ),
                            style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontFamily: 'TextsParagraphs'),
                            items: cityList.map((SelectModel selectiveCity) {
                              return DropdownMenuItem(
                                value: selectiveCity.id,
                                child: Text(selectiveCity.name),
                              );
                            }).toList(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (fieldValue) {
                              if (fieldValue == null) {
                                return 'Ciudad es requerido';
                              }
                              return null;
                            },
                            onChanged: (cityCode) {
                              if (cityCode != null) {
                                cityTextController.text = cityCode;
                                userMainBloc
                                    .add(ChangeLocationDoctorCityEvent(cityCode));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 20.0),
                        Container(
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
                                if (!ubicacionFormKey.currentState!.validate()) {
                                  return;
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                            title: context
                                                .appLocalization.titleWarning,
                                            descriptions:
                                                '¿Estás seguro de activar su servicio?',
                                            isConfirmation: true,
                                            dialogAction: () =>
                                                BlocProvider.of<MainBloc>(context)
                                                    .add(ConnectDoctorAmdEvent(
                                                        locationState:
                                                            stateTextController
                                                                .text,
                                                        locationCity:
                                                            cityTextController
                                                                .text)),
                                            type: AppConstants.statusWarning,
                                            isdialogCancel: true,
                                            dialogCancel: () {});
                                      });
                                }
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
                                      vertical: 15, horizontal: 20),
                                  child: const Text(
                                    'Activar servicio',
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
                                context.go('/home');
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
                                      vertical: 15, horizontal: 20),
                                  child: const Text(
                                    'Regresar',
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
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    stateTextController.dispose();
    cityTextController.dispose();
    super.dispose();
  }
}
