import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/shared/image_build/image_widget.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/bloc/profile_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/controllers/profile_controller.dart';
import '../../../core/models/select_model.dart';
import '../../../shared/bloc_shared/bloc_gender/gender_bloc.dart';
import '../../../shared/image_build/bloc/image_profile_bloc.dart';
import '../../../shared/loading/loading_builder.dart';
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

//_bytesImage = Uint8List.fromList(_bytesImageEmpty.cast<int>());
  late Uint8List? _bytesImage = null;

/*  final List _bytesImageEmpty = [];*/

  final maskPhoneNumber = MaskTextInputFormatter(
      mask: '(###)###-####', filter: {"#": RegExp(r'[0-9]')});
  final maskPhoneNumber2 = MaskTextInputFormatter(
      mask: '(###)###-####', filter: {"#": RegExp(r'[0-9]')});

  late MainBloc userMainBloc;

/*  @override
  void initState() {
    super.initState();
  }
  */
  setData() {
    userMainBloc = BlocProvider.of<MainBloc>(context);
    final state = BlocProvider.of<ProfileBloc>(context, listen: false);
    fullNameCtrl = TextEditingController(text: state.profileModel?.fullName);
    identificationDocumentCtrl =
        TextEditingController(text: state.profileModel?.identificationDocument);
    emailCtrl = TextEditingController(text: state.profileModel?.email);
    genderCtrl = TextEditingController(text: state.profileModel?.gender);
    birthdayCtrl = TextEditingController(
        text:
            '${state.profileModel?.dayBirthday}-${state.profileModel?.monthBirthday}-${state.profileModel?.yearBirthday}');

    dateOfBirthSave =
        '${state.profileModel?.yearBirthday}-${state.profileModel?.monthBirthday}-${state.profileModel?.dayBirthday}';

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
        '${state.profileModel?.yearBirthday}-${state.profileModel?.monthBirthday}${state.profileModel?.dayBirthday}');

    selectedState = state.profileModel?.idState.toString();
    selectedCity = state.profileModel?.idCity.toString();
    selectedGender = state.profileModel!.idGender;
  }

  @override
  Widget build(BuildContext context) {
    setData();

    BlocProvider.of<MainBloc>(context)
        .add(ShowLocationDoctorCitiesEvent(selectedState!));

    userMainBloc
        .add(const ShowLocationDoctorStatesEvent(AppConstants.idCountryVzla));

    return WillPopScope(
      onWillPop: () async => backButtonActions(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppCommonWidgets.generateAppBar(
              context: context, appBarHeight: 140.0),
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      GenderBloc(profileController: ProfileController())
                        ..add(ConsultAllGenderEvent())),
              BlocProvider(create: (context) => ImageProfileBloc())
            ],
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
      listener: (context, state) {
        if (state is ProfileSuccessState) {
        } else if (state is ProfileUpdateSuccessState) {
          context.read<ProfileBloc>().add(GetProfileEvent());
        }
      },
      builder: (context, state) {
        // if (state is ProfileSuccessState) {
        return BlocConsumer<MainBloc, MainState>(
          listener: (context, state) {
            if (state is LocationShowLoadingState) {
              LoadingBuilder(context).showLoadingIndicator(state.message);
            }
            if (state is LocationStatesSuccessState) {
              LoadingBuilder(context).hideOpenDialog();

              stateList = state.listStates;
              userMainBloc.add(ShowLocationDoctorCitiesEvent(stateCtrl.text));
              //selectedState = null;
            }
            if (state is LocationCitiesSuccessState) {
              LoadingBuilder(context).hideOpenDialog();

              cityList = state.listCities;
              selectedState = state.selectedState;

              if (cityCtrl.text.isEmpty) {
                selectedCity = null;
              }
            }

            if (state is ChangeLocationDoctorCityState) {
              selectedCity = state.selectedCity;
            }
          },
          builder: (context, state) {
            return Form(
              child: ListView(
                children: [
                  BlocConsumer<ImageProfileBloc, ImageProfileState>(
                    listener: (context, state) {
                      if (state is ImageChangeSuccessState) {
                        _bytesImage = state.imageBuild;
                      }
                    },
                    builder: (context, state) {
                      return ImageWidget(
                        isEdit: true,
                        color: Colors.blueGrey,
                        imagePath: _bytesImage,
                        onClicked: () async {
                          takeImage(context);
                        },
                      );
                    },
                  ),

                  _fullNameWidget(),
                  _emailWidget(),
                  allGenderList(),
                  _inputBdate(context),
                  _phoneNumberWidget(),
                  _otherPhoneWidget(),
                  _countryWidget(),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30.0, right: 20, left: 20),
                    child: DropdownButtonFormField(
                      hint: Text(context.appLocalization.labelSelect),
                      key: stateFieldKey,
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
                        if (stateCode != null) {
                          stateCtrl.text = stateCode;
                          cityCtrl.clear();
                          selectedCity = null;
                          cityList.clear();
                          userMainBloc
                              .add(ShowLocationDoctorCitiesEvent(stateCode));
                        }
                      },
                      value: selectedState,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30.0, right: 20, left: 20),
                    child: DropdownButtonFormField(
                      hint: Text(context.appLocalization.labelSelect),
                      key: cityFieldKey,
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
                        selectedCity = cityCode;
                        if (cityCode != null) {
                          cityCtrl.text = cityCode;
                          userMainBloc
                              .add(ChangeLocationDoctorCityEvent(cityCode));
                        }
                      },
                      value: selectedCity,
                    ),
                  ),
                  //_cityListWidget(context),
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
                                idAffiliate: BlocProvider.of<ProfileBloc>(
                                        context,
                                        listen: false)
                                    .profileModel!
                                    .idAffiliate!,
                                fullName: fullNameCtrl.text,
                                email: emailCtrl.text,
                                dateOfBirth: dateOfBirthSave!,
                                idGender: selectedGender!,
                                phoneNumber: maskPhoneNumber
                                    .unmaskText(phoneNumberCtrl.text),
                                otherPhone: maskPhoneNumber2
                                    .unmaskText(otherNumberCtrl.text),
                                idCountry: 25,
                                idState: int.parse(selectedState!),
                                idCity: int.parse(selectedCity!),
                                direction: directionCtrl.text,
                                mpps: int.parse(cmppsCtrl.text),
                                cm: int.parse(cmCtrl.text),
                                speciality: specialityCtrl.text));
                          },
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
            );
          },
        );
      },
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
                    return ProfileValidations()
                        .genderValidator(context, value.toString());
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
        validator: (value) =>
            ProfileValidations().mppsValidator(context, value ?? ''),
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
        validator: (value) =>
            ProfileValidations().cmValidator(context, value ?? ''),
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
        validator: (value) =>
            ProfileValidations().specialityValidator(context, value ?? ''),
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
              return ProfileValidations()
                  .bdValidator(context, birthdayCtrl.text);
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

  @override
  void dispose() {
    cityCtrl.dispose();
    stateCtrl.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  takeImage(BuildContext context) async {
    int option;
    option = await _showChoiceDialog();
    if (option == 1) {
      _seletImageGallery(context);
    } else if (option == 2) {
      await _selectImageCamera(context);
    }
  }

  bool invalidatePermissionCamera = true;
  bool invalidatePermissionStorage = true;
  XFile? imagee;

  _selectImageCamera(BuildContext context) async {
    //Navigator.pop(context);

    var cameraPermission = await Permission.camera.request();

    if (cameraPermission == PermissionStatus.permanentlyDenied ||
        cameraPermission == PermissionStatus.restricted) {
      if (invalidatePermissionCamera) {
        //  _importantPermission(S.current.important, S.current.MSG_181, context);
      }
      if (invalidatePermissionCamera == false) {
        invalidatePermissionCamera = true;
      }
    } else if (cameraPermission == PermissionStatus.granted) {
      BlocProvider.of<ImageProfileBloc>(context).add(SelectImageByCamera());
      //context.read<ImageProfileBloc>().add(CleanImageByProfile());
      ///_showChoiceDialog(context);
      // Either the permission was already granted before or the user just granted it.

      /*imagee = await ImagePicker().pickImage(source: ImageSource.camera);
      if (imagee != null) {
        final _path = imagee!.path.toLowerCase();
        final _imageCheck = _path.endsWith('.jpg') ||
            _path.endsWith('.jpeg') ||
            _path.endsWith('.png');
        final _imageSize = (await imagee!.length()) / 1000;
        _cropImage(imagee!.path);
        //imageRaw = await imagee!.readAsBytes();
        print(await imagee!.length());
      }*/
    } else if (cameraPermission == PermissionStatus.denied) {
      invalidatePermissionCamera = false;
    }
  }

  _seletImageGallery(context) async {
    PermissionStatus storagePermission;

    if (Platform.isAndroid) {
      storagePermission = await Permission.storage.request();
    } else {
      storagePermission = await Permission.photos.request();
      print(storagePermission);
    }

    if (storagePermission == PermissionStatus.granted ||
        storagePermission == PermissionStatus.limited) {
      BlocProvider.of<ImageProfileBloc>(context).add(SelectImageByGallery());
    } else if (storagePermission == PermissionStatus.permanentlyDenied ||
        storagePermission == PermissionStatus.restricted) {
      if (invalidatePermissionStorage) {
        // _importantPermission(S.current.important, S.current.MSG_181, context);
      }
      if (!invalidatePermissionStorage) {
        invalidatePermissionStorage = true;
      }
    } else if (storagePermission == PermissionStatus.denied) {
      invalidatePermissionStorage = false;
    }
  }

  Future<int> _showChoiceDialog() async {
    int selectionOption = 0;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Elige una opción",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      selectionOption = 1;
                      context.pop();
                      //_seletImageGallery();
                    },
                    title: Text('Galeria'),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      context.pop();
                      selectionOption = 2;
                      //_selectImageCamera(context);
                      /// context.read<ImageProfileBloc>().add(SelectImageByCamera());
                    },
                    title: Text('Camara'),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                  _bytesImage != null
                      ? ListTile(
                          onTap: () {
                            selectionOption = 3;
                          },
                          title: Text('Borrar imagen'),
                          leading: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
    return selectionOption;
  }
}
