import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '/app/pages/styles/app_styles.dart';
import '/app/core/models/select_model.dart';
import '/app/extensions/localization_ext.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/main/bloc/main_bloc.dart';
import '/app/shared/dialog/custom_dialog_box.dart';
import '/app/shared/loading/loading_builder.dart';
import '/app/shared/method/back_button_action.dart';

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
    bool activateButton = true;
    MainBloc userMainBloc = BlocProvider.of<MainBloc>(context);
    userMainBloc
        .add(const ShowLocationDoctorStatesEvent(AppConstants.idCountryVzla));
    return WillPopScope(
      onWillPop: () => backButtonActions(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppStyles.colorBluePrimary,
            toolbarHeight: 140.0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: Image.asset(
                      AppConstants.logoImageWhite,
                      width: 270,
                      height: 90,
                    ))
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Icon(AppConstants.iconsMenu['doctorLocation'],
                        color: AppStyles.colorWhite),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      context.appLocalization.titleDoctorLocation,
                      style: AppStyles.textStyleTitle,
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
                  }).then((value) {
                context.go(GeoAmdRoutes.home, extra: DoctorServiceState);
              });
            }
            if (state is DoctorServiceErrorState) {
              LoadingBuilder(context).hideOpenDialog();
              activateButton = true;
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
            if (state is DisableButtonState) {
              activateButton = false;
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
                    Row(
                      children: [
                        Flexible(
                            child: Text(
                          context.appLocalization.messageDoctorLocation,
                          textAlign: TextAlign.justify,
                          style: AppStyles.textStyleOnlineDoctor,
                        )),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            hint: Text(context.appLocalization.labelSelect),
                            key: estadoFieldKey,
                            value: selectedState,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppStyles.colorBluePrimary)),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppStyles.colorBluePrimary)),
                                hintText: context.appLocalization.labelSelect,
                                labelText: context.appLocalization.labelState,
                                labelStyle: AppStyles.textStyleSelect,
                                errorStyle: AppStyles.textFormFieldError),
                            style: AppStyles.textStyleOptionSelect,
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
                                return context.appLocalization.fieldRequired;
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
                            hint: Text(context.appLocalization.labelSelect),
                            key: ciudadFieldKey,
                            value: selectedCity,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppStyles.colorBluePrimary)),
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppStyles.colorBluePrimary)),
                                labelText: context.appLocalization.labelCity,
                                hintText: context.appLocalization.labelSelect,
                                labelStyle: AppStyles.textStyleSelect,
                                errorStyle: AppStyles.textFormFieldError),
                            style: AppStyles.textStyleOptionSelect,
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
                                return context.appLocalization.fieldRequired;
                              }
                              return null;
                            },
                            onChanged: (cityCode) {
                              if (cityCode != null) {
                                cityTextController.text = cityCode;
                                userMainBloc.add(
                                    ChangeLocationDoctorCityEvent(cityCode));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 5,
                              side: const BorderSide(
                                  width: 2, color: Color(0xffFFFFFF)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: activateButton
                              ? () => context.go(GeoAmdRoutes.home)
                              : null,
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: activateButton
                                    ? const LinearGradient(colors: [
                                        Color(0xffF96352),
                                        Color(0xffD84835)
                                      ])
                                    : const LinearGradient(colors: [
                                        AppStyles.colorGray,
                                        AppStyles.colorGray
                                      ]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 36),
                              child: Text(
                                context.appLocalization.nameButtonReturn,
                                textAlign: TextAlign.center,
                                style: AppStyles.textStyleButton,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 5,
                              side: const BorderSide(
                                  width: 2, color: Color(0xffFFFFFF)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: activateButton
                              ? () {
                                  if (!ubicacionFormKey.currentState!
                                      .validate()) {
                                    return;
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                              title: context
                                                  .appLocalization.titleWarning,
                                              descriptions: context
                                                  .appLocalization
                                                  .messageConnectDoctor,
                                              isConfirmation: true,
                                              dialogAction: () => BlocProvider
                                                      .of<MainBloc>(context)
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
                                }
                              : null,
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: activateButton
                                    ? const LinearGradient(colors: [
                                        Color(0xff2B5178),
                                        Color(0xff273456)
                                      ])
                                    : const LinearGradient(colors: [
                                        AppStyles.colorGray,
                                        AppStyles.colorGray
                                      ]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              child: Text(
                                context.appLocalization.nameButtonConnectDoctor,
                                textAlign: TextAlign.center,
                                style: AppStyles.textStyleButton,
                              ),
                            ),
                          ),
                        ),
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
