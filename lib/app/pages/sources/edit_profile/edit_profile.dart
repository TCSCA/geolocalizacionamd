import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/sources/edit_profile/widgets/all_gender_widget.dart';
import 'package:geolocalizacionamd/app/pages/sources/edit_profile/widgets/build_textfield_widget.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/bloc/profile_bloc.dart';
import '../../../core/models/select_model.dart';
import '../../../shared/method/back_button_action.dart';
import '../../constants/app_constants.dart';
import '../../styles/app_styles.dart';
import '../../widgets/common_widgets.dart';
import '../main/bloc/main_bloc.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> stateFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> cityFieldKey = GlobalKey<FormFieldState>();

  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController identificationDocumentCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController genderCtrl = TextEditingController();
  TextEditingController birthdayCtrl = TextEditingController();
  TextEditingController phoneNumberCtrl = TextEditingController();
  TextEditingController otherNumberCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  TextEditingController countryCtrl = TextEditingController();
  TextEditingController directionCtrl = TextEditingController();
  TextEditingController cmppsCtrl = TextEditingController();
  TextEditingController cmCtrl = TextEditingController();
  TextEditingController specialityCtrl = TextEditingController();
  TextEditingController photoCtrl = TextEditingController();
  TextEditingController firmaCtrl = TextEditingController();
  DateTime? selectedDate;

  List<SelectModel> stateList = [];
  List<SelectModel> cityList = [];

  String? selectedCity;
  String? selectedState;

  late MainBloc userMainBloc;



  @override
  Widget build(BuildContext context) {
    userMainBloc = BlocProvider.of<MainBloc>(context);
    userMainBloc
        .add(const ShowLocationDoctorStatesEvent(AppConstants.idCountryVzla));

    setDataInfo(context);

    return /*BlocProvider.value(
      value: BlocProvider.of<ProfileBloc>(context),
      child:*/
        WillPopScope(
      onWillPop: () async => backButtonActions(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppCommonWidgets.generateAppBar(
              context: context, appBarHeight: 140.0),
          body: MultiBlocListener(
            listeners: [
              //NavigationBloc y LogoutBloc comunes en todas las paginas.
              AppCommonWidgets.listenerNavigationBloc(),
              AppCommonWidgets.listenerLogoutBloc()
            ],
            child: Container(
              padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
              child: buildListView(),
            ),
          ),
        ),
      ),
    );
    //  );
  }

  Widget buildListView() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccessState) {
          identificationDocumentCtrl = TextEditingController(
              text: state.profileModel.identificationDocument);
          emailCtrl = TextEditingController(
              text: state.profileModel.identificationDocument);
          genderCtrl = TextEditingController(text: state.profileModel.gender);
          birthdayCtrl = TextEditingController(
              text:
                  '${state.profileModel.dayBirthday}-${state.profileModel.monthBirthday}-${state.profileModel.yearBirthday}');
          phoneNumberCtrl =
              TextEditingController(text: state.profileModel.phoneNumber);
          otherNumberCtrl =
              TextEditingController(text: state.profileModel.otherNumber);
          cityCtrl = TextEditingController(text: state.profileModel.city);
          stateCtrl = TextEditingController(text: state.profileModel.state);
          countryCtrl = TextEditingController(text: state.profileModel.country);
          directionCtrl =
              TextEditingController(text: state.profileModel.direction);
          cmppsCtrl = TextEditingController(text: state.profileModel.mpps);
          cmCtrl = TextEditingController(text: state.profileModel.mc);
          specialityCtrl =
              TextEditingController(text: state.profileModel.speciality);
        }
      },
      builder: (context, state) {
        if (state is ProfileSuccessState) {
          return ListView(
            children: [

              BuildTextFieldWidget(
                labelText: context.appLocalization.labelFullName,
                placeHolder: state.profileModel.fullName ?? '',
                isReadOnly: false,
                textController: fullNameCtrl,
              ),
              /*BuildTextFieldWidget(
                labelText: context.appLocalization.labelIdentificationDocument,
                placeHolder: state.profileModel.identificationDocument ?? '',
                isReadOnly: false,
                textController: identificationDocumentCtrl,
              ),*/
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelEmail,
                placeHolder: state.profileModel.email ?? '',
                isReadOnly: false,
                textController: emailCtrl,
              ),
              /*BuildTextFieldWidget(
                labelText: context.appLocalization.labelGender,
                placeHolder: state.profileModel.gender ?? '',
                isReadOnly: false,
                textController: genderCtrl,
              )*/
              const AllGenderWidget(),
              _inputBdate(context),
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelPhone,
                placeHolder: state.profileModel.phoneNumber ?? '',
                isReadOnly: false,
                textController: phoneNumberCtrl,
              ),
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelOtherPhone,
                placeHolder: state.profileModel.otherNumber ?? '',
                isReadOnly: false,
                textController: otherNumberCtrl,
              ),
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelCountry,
                placeHolder: state.profileModel.city ?? '',
                isReadOnly: true,
                textController: countryCtrl,
              ),
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelState,
                placeHolder: state.profileModel.state ?? '',
                isReadOnly: false,
                textController: stateCtrl,
              ),
              //_stateList(),
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelCity,
                placeHolder: state.profileModel.country ?? '',
                isReadOnly: false,
                textController: cityCtrl,
              ),
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelDirection,
                placeHolder: state.profileModel.direction ?? '',
                isReadOnly: false,
                textController: directionCtrl,
              ),
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelMPPS,
                placeHolder: '0000000000',
                isReadOnly: true,
                textController: cmppsCtrl,
              ),
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelCM,
                placeHolder: '0000000000',
                isReadOnly: true,
                textController: cmCtrl,
              ),
              BuildTextFieldWidget(
                labelText: context.appLocalization.labelSpeciality,
                placeHolder: state.profileModel.speciality ?? '',
                isReadOnly: true,
                textController: specialityCtrl,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print(identificationDocumentCtrl);
                        }
                        // context.read<ProfileBloc>().add(GetProfileEvent());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  setDataInfo(BuildContext context) {
    fullNameCtrl = TextEditingController(
        text: context.select(
            (ProfileBloc profileBloc) => profileBloc.profileModel?.fullName));

    identificationDocumentCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
            profileBloc.profileModel?.identificationDocument));
    emailCtrl = TextEditingController(
        text: context.select(
            (ProfileBloc profileBloc) => profileBloc.profileModel?.email));

    genderCtrl = TextEditingController(
        text: context.select(
            (ProfileBloc profileBloc) => profileBloc.profileModel?.gender));

    birthdayCtrl =
        TextEditingController(text: context.select((ProfileBloc profileBloc) {
      final day = profileBloc.profileModel?.dayBirthday;
      final month = profileBloc.profileModel?.monthBirthday;
      final year = profileBloc.profileModel?.yearBirthday;
      return '$day-$month-$year';
    }));

    phoneNumberCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
            profileBloc.profileModel?.phoneNumber));

    otherNumberCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
            profileBloc.profileModel?.otherNumber));

    countryCtrl = TextEditingController(
        text: context.select(
            (ProfileBloc profileBloc) => profileBloc.profileModel?.country));

    stateCtrl = TextEditingController(
        text: context.select(
            (ProfileBloc profileBloc) => profileBloc.profileModel?.state));

    cityCtrl = TextEditingController(
        text: context.select(
            (ProfileBloc profileBloc) => profileBloc.profileModel?.city));

    directionCtrl = TextEditingController(
        text: context.select(
            (ProfileBloc profileBloc) => profileBloc.profileModel?.direction));

    selectedDate = DateTime.parse(context.select((ProfileBloc profileBloc) {
      final day = profileBloc.profileModel?.dayBirthday;
      final month = profileBloc.profileModel?.monthBirthday;
      final year = profileBloc.profileModel?.yearBirthday;
      return '$year-$month-$day';
    }));

    cmppsCtrl = TextEditingController(
        text: context.select(
            (ProfileBloc profileBloc) => profileBloc.profileModel?.mpps));

    cmCtrl = TextEditingController(
        text: context
            .select((ProfileBloc profileBloc) => profileBloc.profileModel?.mc));

    specialityCtrl = TextEditingController(
        text: context.select(
            (ProfileBloc profileBloc) => profileBloc.profileModel?.speciality));
  }

  Widget _inputBdate(BuildContext context /*, EdgeInsets style*/) {
    /*return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {*/
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.appLocalization.labelDateOfBirth}(*)',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextFormField(
            controller: birthdayCtrl,
            autovalidateMode: AutovalidateMode.always,
            // key: _bdKey,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            validator: (value) {
              return null;

              /// return bdValidator(date);
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
              //hintStyle: fontTextBlack,
              errorMaxLines: 2,
              //hintText: date,
              counterStyle: const TextStyle(color: Colors.black),
              focusedBorder: const UnderlineInputBorder(
                  //borderSide: BorderSide(color: secondaryColor, width: 2),
                  ),

              errorStyle:
                  const TextStyle(/*color: tertiaryColor,*/ fontSize: 14),
              /*errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor)),*/
              suffixIcon: Icon(
                Icons.calendar_today,
                color: Colors.black.withOpacity(0.5),
              ),
              /*focusedErrorBorder: const UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: secondaryColor, width: 2.0)),*/
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              await _selectDate(context);
              //_dateValid = _bdKey.currentState!.validate();
              // _saveButtonEnable = _isFormValid();
              String dateDay = selectedDate!.day.toString();
              String dateMonth = selectedDate!.month.toString();

              if (int.parse(selectedDate!.month.toString()) < 10) {
                dateMonth = '0${int.parse(selectedDate!.month.toString())}';
              }
              if (int.parse(selectedDate!.day.toString()) < 10) {
                dateDay = '0${int.parse(selectedDate!.day.toString())}';
              }
              birthdayCtrl = TextEditingController(
                  text: '$dateDay-$dateMonth-${selectedDate!.year}');
              //date = '$dateDay/$dateMonth/${selectedDate!.year}';

              /*context.read<EditProfileBloc>().add(EditDateOfBird(
                      dateOfbird: '${selectedDate.year}-$dateMonth-$dateDay'));*/

              // dateOfBirthSave = '${selectedDate!.year}-$dateMonth-$dateDay';
            },
            onChanged: (value) {
              // setState(() {
              // date;
              // _dateValid = _bdKey.currentState!.validate();
              // _saveButtonEnable = _isFormValid();
              //});
            },
          ),
        ],
      ),
      //   );
      //  },
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      locale: const Locale('es', 'MX'),
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      cancelText: context.appLocalization.nameButtonCancel,
      confirmText: context.appLocalization.nameButtonAccept,
      helpText: '${context.appLocalization.labelDateOfBirth} (*)',
      fieldHintText: context.appLocalization.dateFormat,
      fieldLabelText: '${context.appLocalization.labelDateOfBirth} (*)',
    ).then((value) {
      print(value);

      if (value == null) {
        DateTime dt = DateTime.parse(selectedDate.toString());

        /// setState(() {
        selectedDate = dt;
        //});
      }
      if (value != null && value != selectedDate) {
        //setState(() {
        selectedDate = value;
        // });
      }
      return null;
    });
  }

  Widget _stateList() {
    return BlocConsumer<MainBloc, MainState>(
  listener: (context, state) {
    if (state is LocationStatesSuccessState) {
      ///LoadingBuilder(context).hideOpenDialog();
      stateList = state.listStates;
      //selectedState = null;
    }
    if (state is LocationCitiesSuccessState) {
     /// LoadingBuilder(context).hideOpenDialog();
      cityList = state.listCities;
      selectedState = state.selectedState;
      selectedCity = null;
    }
  },
  builder: (context, state) {
    return Column(
      children: [
        ListView(
          children: [
            /*Expanded(
              child:*/ DropdownButtonFormField(
                hint: Text(context.appLocalization.labelSelect),
                //key: estadoFieldKey,
                //value: selectedState,
                decoration: InputDecoration(
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
                    stateCtrl.text = stateCode;
                    userMainBloc.add(
                        ShowLocationDoctorCitiesEvent(stateCode));
                  }
                },
              ),
          //  )
          ],
        ),
        Row(
          children: <Widget>[
            /*Expanded(
              child:*/ DropdownButtonFormField(
                hint: Text(context.appLocalization.labelSelect),
                key: cityFieldKey,
                value: selectedCity,
                decoration: InputDecoration(
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
                    cityCtrl.text = cityCode;
                    userMainBloc.add(
                        ChangeLocationDoctorCityEvent(cityCode));
                  }
                },
              ),
           // ),
          ],
        ),
      ],
    );
  },
);
  }
}
