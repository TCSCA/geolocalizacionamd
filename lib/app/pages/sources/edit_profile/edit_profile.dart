import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/bloc/profile_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../core/controllers/profile_controller.dart';
import '../../../core/models/select_model.dart';
import '../../../shared/bloc_shared/bloc_gender/gender_bloc.dart';
import '../../../shared/method/back_button_action.dart';
import '../../constants/app_constants.dart';
import '../../styles/app_styles.dart';
import '../../validations/profile_validations.dart';
import '../../widgets/common_widgets.dart';
import '../main/bloc/main_bloc.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState> fullNameFieldKey =
  GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> emailFielKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> genderFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> birthdayFieldKey =
  GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> phoneNumberFieldKey =
  GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> otherNumberFieldKey =
  GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> cityFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> stateFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> countryFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> directionFieldKey =
  GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> mppsFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> cmFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> specialityFieldKey =
  GlobalKey<FormFieldState>();

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
  int? selectedGender;
  String? dateOfBirthSave;

  final maskPhoneNumber = MaskTextInputFormatter(
      mask: '(###)###-####', filter: {"#": RegExp(r'[0-9]')});
  final maskPhoneNumber2 = MaskTextInputFormatter(
      mask: '(###)###-####', filter: {"#": RegExp(r'[0-9]')});

  late MainBloc userMainBloc;

  @override
  void initState() {
    super.initState();

    final state = BlocProvider.of<ProfileBloc>(context, listen: false);
    fullNameCtrl = TextEditingController(text: state.profileModel?.fullName);
    identificationDocumentCtrl =
        TextEditingController(text: state.profileModel?.identificationDocument);
    emailCtrl = TextEditingController(text: state.profileModel?.email);
    genderCtrl = TextEditingController(text: state.profileModel?.gender);
    birthdayCtrl = TextEditingController(
        text:
        '${state.profileModel?.dayBirthday}-${state.profileModel
            ?.monthBirthday}-${state.profileModel?.yearBirthday}');

    dateOfBirthSave = '${state.profileModel?.yearBirthday}-${state.profileModel
        ?.monthBirthday}-${state.profileModel?.dayBirthday}';

    phoneNumberCtrl = TextEditingController(
        text: maskPhoneNumber.maskText(state.profileModel?.phoneNumber ?? ''));
    otherNumberCtrl = TextEditingController(
        text: maskPhoneNumber2.maskText(state.profileModel?.otherNumber ?? ''));
    cityCtrl = TextEditingController(text: state.profileModel?.city);
    stateCtrl = TextEditingController(text: state.profileModel?.state);
    countryCtrl = TextEditingController(text: state.profileModel?.country);
    directionCtrl = TextEditingController(text: state.profileModel?.direction);
    cmppsCtrl = TextEditingController(text: state.profileModel?.mpps);
    cmCtrl = TextEditingController(text: state.profileModel?.mc);

    specialityCtrl =
        TextEditingController(text: state.profileModel?.speciality);
    selectedDate = DateTime.parse(
        '${state.profileModel?.yearBirthday}-${state.profileModel
            ?.monthBirthday}${state.profileModel?.dayBirthday}');

    selectedState = state.profileModel?.idState.toString();
    selectedCity = state.profileModel?.idCity.toString();
    selectedGender = state.profileModel!.idGender;

    BlocProvider.of<MainBloc>(context)
        .add(ShowLocationDoctorCitiesEvent(selectedState!));
  }

  @override
  Widget build(BuildContext context) {
    userMainBloc = BlocProvider.of<MainBloc>(context);
    userMainBloc.add(
        const ShowLocationDoctorStatesEvent(AppConstants.idCountryVzla));

    return WillPopScope(
        onWillPop: () async => backButtonActions(),
        child: SafeArea(
          child: Scaffold(
            appBar: AppCommonWidgets.generateAppBar(
                context: context, appBarHeight: 140.0),
            body: BlocProvider(
              create: (context) =>
              GenderBloc(profileController: ProfileController())
                ..add(ConsultAllGenderEvent()),
              child: MultiBlocListener(
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
        ),
      );
    //  );
  }

  Widget buildListView() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) => current is ProfileSuccessState,
      buildWhen: (previous, current) => current is! ProfileSuccessState,
      listener: (context, state) {
        if (state is ProfileSuccessState) {}
      },
      builder: (context, state) {
        if (state is ProfileSuccessState) {
          return BlocListener<MainBloc, MainState>(
            listener: (context, state) {
              if (state is LocationStatesSuccessState) {
                setState(() {
                  stateList = state.listStates;
                });

                //  selectedState = null;
              }
              if (state is LocationCitiesSuccessState) {
                setState(() {
                  cityList = state.listCities;
                });

                selectedState = state.selectedState;
                // selectedCity = null;
              }
            },
            child: Form(
              child: ListView(
                children: [
                  _fullNameWidget(),
                  _emailWidget(),
                   allGenderList(),
                  _inputBdate(context),
                  _phoneNumberWidget(),
                  _otherPhoneWidget(),
                  _countryWidget(),
                  _stateListWidget(context),
                  _cityListWidget(context),
                  _directionWidget(),
                  _mppsWidget(),
                  _cmWidget(),
                  _specialityWidget(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 30),
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
                            context.read<ProfileBloc>().add(EditProfileEvent(
                              idAffiliate: BlocProvider.of<ProfileBloc>(context, listen: false).profileModel!.idAffiliate!,
                              fullName: fullNameCtrl.text,
                              email: emailCtrl.text,
                              dateOfBirth: dateOfBirthSave!,
                              idGender: selectedGender!,
                              phoneNumber: maskPhoneNumber.unmaskText(phoneNumberCtrl.text),
                              otherPhone: maskPhoneNumber2.unmaskText(otherNumberCtrl.text),
                              idCountry:  58,
                              idState: int.parse(selectedState!),
                              idCity: int.parse(selectedCity!),
                              direction: directionCtrl.text,
                              mpps: int.parse(cmppsCtrl.text),
                              cm: int.parse(cmCtrl.text),
                              speciality: specialityCtrl.text

                            ));
                          } ,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 30),
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
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Padding _cityListWidget(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 30.0, right: 20, left: 20),
                  child: DropdownButtonFormField(
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
                    autovalidateMode: AutovalidateMode.always,
                    validator: (fieldValue) {
                      if (fieldValue == null) {
                        return context.appLocalization.fieldRequired;
                      }
                      return null;
                    },
                    onChanged: (cityCode) {
                      if (cityCode != null) {
                        cityCtrl.text = cityCode;
                        userMainBloc
                            .add(ChangeLocationDoctorCityEvent(cityCode));
                      }
                    },
                  ),
                );
  }

  Padding _stateListWidget(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 30.0, right: 20, left: 20),
                  child: DropdownButtonFormField(
                    hint: Text(context.appLocalization.labelSelect),
                    key: stateFieldKey,
                    value: selectedState,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (fieldValue) {
                      if (fieldValue == null) {
                        return context.appLocalization.fieldRequired;
                      }
                      return null;
                    },
                    onChanged: (stateCode) {
                      selectedCity = null;
                      if (stateCode != null) {
                        stateCtrl.text = stateCode;
                        userMainBloc
                            .add(ShowLocationDoctorCitiesEvent(stateCode));
                      }
                    },
                  ),
                );
  }

  Widget allGenderList() {
    return BlocBuilder<GenderBloc, GenderState>(
      builder: (context, state) {
        if (state is GenderDataSuccessState) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appLocalization.labelGender,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
                DropdownButtonFormField(
                  autovalidateMode: AutovalidateMode.always,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  // style: fontTextBlack,
                   key: genderFieldKey,
                  validator: (value) {
                     return ProfileValidations().genderValidator(context, value.toString());
                  },
                  items: state.genderMap.data.map((item) {
                    return DropdownMenuItem(
                      value: item.idGender,
                      child: Text(item.descriptionEs),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    genderFieldKey.currentState!.validate();
                    selectedGender = newVal;
                  },
                  onTap: () {
                    genderFieldKey.currentState!.validate();
                    /* _genderValid = _genderKey.currentState!.validate();
                    _saveButtonEnable = _isFormValid();*/
                  },
                  value: selectedGender,
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _fullNameWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: fullNameCtrl,
        readOnly: false,
        minLines: 1,
        maxLines: 5,
        key: fullNameFieldKey,
        validator: (value) =>
            ProfileValidations().fullnameValidator(context, value ?? ''),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: context.appLocalization.labelFullName,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _emailWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: emailCtrl,
        readOnly: false,
        minLines: 1,
        maxLines: 5,
        key: emailFielKey,
        validator: (value) =>
            ProfileValidations().emailValidator(context, value ?? ''),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: context.appLocalization.labelEmail,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _phoneNumberWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: phoneNumberCtrl,
        inputFormatters: [maskPhoneNumber],
        //readOnly: isReadOnly,
        minLines: 1,
        maxLines: 5,
        key: phoneNumberFieldKey,
        validator: (value) =>
            ProfileValidations().numberValidator(context, value ?? ''),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: context.appLocalization.labelPhone,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _otherPhoneWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: otherNumberCtrl,
        inputFormatters: [maskPhoneNumber2],
        //readOnly: isReadOnly,
        minLines: 1,
        maxLines: 5,
        key: otherNumberFieldKey,
        validator: (value) =>
            ProfileValidations().otherNumberValidator(context, value ?? ''),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: context.appLocalization.labelPhone,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _countryWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextFormField(
        controller: countryCtrl,
        readOnly: true,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: context.appLocalization.labelCountry,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _directionWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: directionCtrl,
        readOnly: false,
        minLines: 1,
        maxLines: 5,
        key: directionFieldKey,
        validator: (value) =>
            ProfileValidations().directionValidator(context, value ?? ''),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: context.appLocalization.labelDirection,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _mppsWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: cmppsCtrl,
        readOnly: false,
        minLines: 1,
        maxLines: 5,
        key: mppsFieldKey,
        validator: (value) => ProfileValidations().mppsValidator(context, value ?? ''),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: context.appLocalization.labelMPPS,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _cmWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: cmCtrl,
        readOnly: false,
        minLines: 1,
        maxLines: 5,
        key: cmFieldKey,
        validator: (value) => ProfileValidations().cmValidator(context, value ?? ''),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: context.appLocalization.labelCM,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _specialityWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        controller: specialityCtrl,
        readOnly: false,
        minLines: 1,
        maxLines: 5,
        key: specialityFieldKey,
        validator: (value) => ProfileValidations().specialityValidator(context, value ?? ''),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: context.appLocalization.labelSpeciality,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  /* setDataInfo(BuildContext context) {
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
  }*/

  Widget _inputBdate(BuildContext context) {
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
            key: birthdayFieldKey,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            validator: (value) {
              return ProfileValidations().bdValidator(context, birthdayCtrl.text);
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
              birthdayFieldKey.currentState!.validate();

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


               dateOfBirthSave = '${selectedDate!.year}-$dateMonth-$dateDay';
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
}