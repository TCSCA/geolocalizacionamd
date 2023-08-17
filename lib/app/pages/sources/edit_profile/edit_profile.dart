import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/shared/digital_signature_bloc/digital_signature_bloc.dart';
import 'package:geolocalizacionamd/app/shared/image_build/image_widget.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/bloc/profile_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../core/controllers/profile_controller.dart';
import '../../../core/models/select_model.dart';
import '../../../shared/bloc_shared/bloc_gender/gender_bloc.dart';
import '../../../shared/dialog/custom_dialog_box.dart';
import '../../../shared/image_build/bloc/image_profile_bloc.dart';
import '../../../shared/loading/loading_builder.dart';
import '../../../shared/method/back_button_action.dart';
import '../../constants/app_constants.dart';
import '../../messages/app_messages.dart';
import '../../routes/geoamd_route.dart';
import '../../styles/app_styles.dart';
import '../../validations/profile_validations.dart';
import '../../widgets/common_widgets.dart';
import '../main/bloc/main_bloc.dart';
import '../navigation/bloc/navigation_bloc.dart';

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
  Uint8List? _bytesImage;
  Uint8List? _imgByDatabase;
  String? pathImage;

  Uint8List? doctorSignatureBuild = null;
  String? doctorSignaturePath;

/*  final List _bytesImageEmpty = [];*/

  final maskPhoneNumber = MaskTextInputFormatter(
      mask: '(###)###-####', filter: {"#": RegExp(r'[0-9]')});
  final maskPhoneNumber2 = MaskTextInputFormatter(
      mask: '(###)###-####', filter: {"#": RegExp(r'[0-9]')});

  late MainBloc userMainBloc;
  setData() {
    userMainBloc = BlocProvider.of<MainBloc>(context);
    final imageProfile = BlocProvider.of<ImageProfileBloc>(context).state;

    final state = BlocProvider.of<ProfileBloc>(context, listen: false);

    final imageState = BlocProvider.of<ImageProfileBloc>(context, listen: false);
    fullNameCtrl = TextEditingController(text: state.profileModel?.fullName);
    identificationDocumentCtrl =
        TextEditingController(text: state.profileModel?.identificationDocument);
    emailCtrl = TextEditingController(text: state.profileModel?.email);
    genderCtrl = TextEditingController(text: state.profileModel?.gender);
    birthdayCtrl = TextEditingController(
        text:
            '${state.profileModel?.dayBirthday}/${state.profileModel?.monthBirthday}/${state.profileModel?.yearBirthday}');

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
    _bytesImage = imageProfile is InitialImageProfileState ? imageProfile.imageBuild : null;
    _imgByDatabase = imageProfile is InitialImageProfileState ? imageProfile.imageBuild : null;

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
      listener: (context, state) async {
        if (state is ProfileUpdateLoadingState) {
          LoadingBuilder(context).showLoadingIndicator('Cardando perfil');
        }
        if (state is ProfileSuccessState) {
          LoadingBuilder(context).hideOpenDialog();
        } else if (state is ProfileUpdateSuccessState) {
          BlocProvider.of<ImageProfileBloc>(context).add(ConsultPhotoEvent());
          LoadingBuilder(context).hideOpenDialog();
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages()
                      .getMessageTitle(context, AppConstants.statusSuccess),
                  descriptions:
                      AppMessages().getMessage(context, context.appLocalization.successUpdateData),
                  isConfirmation: false,
                  dialogAction: () {},
                  type: AppConstants.statusSuccess,
                  isdialogCancel: false,
                  dialogCancel: () {},
                );
              });

          context.read<ProfileBloc>().add(GetProfileInitialEvent());
          context.go(GeoAmdRoutes.profile, extra: NavigationBloc());
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
              selectedState = stateCtrl.text;
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
              key: editFormKey,
              child: ListView(
                children: [
                  BlocConsumer<ImageProfileBloc, ImageProfileState>(
                    listener: (context, state) {
                      if (state is ImageChangeSuccessState) {
                        _bytesImage = state.imageBuild;
                        pathImage = state.imagePath;
                      } else if (state is CameraPermissionSuccessState) {
                        if (state.typePermission == 'gallery') {
                          context
                              .read<ImageProfileBloc>()
                              .add(SelectImageByGallery());
                        } else if (state.typePermission == 'camera') {
                          context
                              .read<ImageProfileBloc>()
                              .add(SelectImageByCamera());
                        }
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
                  const SizedBox(
                    height: 30,
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
                          labelText:
                              '${context.appLocalization.labelState} (*)',
                          labelStyle: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
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
                          labelText: '${context.appLocalization.labelCity} (*)',
                          hintText: context.appLocalization.labelSelect,
                          labelStyle: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
                        child: Text(
                          'Firma Cargada',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      MaterialButton(
                            child: const Icon(Icons.drive_folder_upload, size: 30, color: Color(0xff2B5178),),
                            onPressed: () {
                              context
                                  .read<DigitalSignatureBloc>().add(SelectDoctorSignatureEvent());
                            }),
                     // ),
                    ],
                  ),
                  BlocConsumer<DigitalSignatureBloc, DigitalSignatureState>(
                    listener: (context, state) {
                      if (state is DigitalSignatureSuccess) {
                        doctorSignaturePath = state.doctorSignaturePath;
                        doctorSignatureBuild = state.doctorSignatureBuild;
                      }
                    },
                    builder: (context, state) {
                      if (state is DigitalSignatureSuccess) {
                        return Column(
                          children: [
                            _digitalSignatureDoctor(doctorSignatureBuild),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 20.0),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    elevation: 5,
                                    side: const BorderSide(
                                        width: 2, color: Color(0xffFFFFFF)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomDialogBox(
                                            title: context
                                                .appLocalization.titleWarning,
                                            descriptions:
                                            context.appLocalization.alertCancel,
                                            isConfirmation: true,
                                            dialogAction: () {
                                              BlocProvider.of<ImageProfileBloc>(context).add(ImageProfileInitialEvent(imageBuild: _imgByDatabase));
                                              context.go(GeoAmdRoutes.profile);
                                            },
                                            type: AppConstants.statusWarning,
                                            isdialogCancel: true,
                                            dialogCancel: () {});
                                      });

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
                                    child: Text(
                                      context.appLocalization.nameButtonCancel,
                                      textAlign: TextAlign.center,
                                      style: AppStyles.textStyleButton,
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    elevation: 5,
                                    side: const BorderSide(
                                        width: 2, color: Color(0xffFFFFFF)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onPressed: () {
                                  if (!editFormKey.currentState!.validate()) {
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
                                                  context.appLocalization.confirmSaveData,
                                              isConfirmation: true,
                                              dialogAction: () => context.read<ProfileBloc>().add(EditProfileEvent(
                                                  idAffiliate:
                                                      BlocProvider.of<ProfileBloc>(
                                                              context,
                                                              listen: false)
                                                          .profileModel!
                                                          .idAffiliate!,
                                                  fullName: fullNameCtrl.text,
                                                  email: emailCtrl.text,
                                                  dateOfBirth: dateOfBirthSave!,
                                                  idGender: selectedGender!,
                                                  phoneNumber: maskPhoneNumber
                                                      .unmaskText(
                                                          phoneNumberCtrl.text),
                                                  otherPhone: maskPhoneNumber2
                                                      .unmaskText(
                                                          otherNumberCtrl.text),
                                                  idCountry: 25,
                                                  idState:
                                                      int.parse(selectedState!),
                                                  idCity: int.parse(selectedCity!),
                                                  direction: directionCtrl.text,
                                                  mpps: int.parse(cmppsCtrl.text),
                                                  cm: int.parse(cmCtrl.text),
                                                  speciality: specialityCtrl.text,
                                                  photoProfile: pathImage,
                                                  digitalSignature: doctorSignaturePath)),
                                              type: AppConstants.statusWarning,
                                              isdialogCancel: true,
                                              dialogCancel: () {});
                                        });
                                  }
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
                                    child: Text('Guardar',
                                      textAlign: TextAlign.center,
                                      style: AppStyles.textStyleButton,
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      )
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
              child: DropdownButtonFormField(
                hint: Text(context.appLocalization.labelGender),
                decoration: InputDecoration(
                    labelText: '${context.appLocalization.labelGender} (*)',
                    hintText: context.appLocalization.labelSelect,
                    labelStyle: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    errorStyle: AppStyles.textFormFieldError),
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
              /*    ],
            ),*/
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
        maxLength: 50,
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
            labelText: '${context.appLocalization.labelFullName} (*)',
            labelStyle: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _emailWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 20, left: 20),
      child: TextFormField(
        maxLength: 50,
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
            labelText: '${context.appLocalization.labelEmail} (*)',
            labelStyle: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
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
        keyboardType: TextInputType.number,
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
            labelText: '${context.appLocalization.labelPhone} (*)',
            labelStyle: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
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
        keyboardType: TextInputType.number,
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
            labelText: context.appLocalization.labelOtherPhone,
            labelStyle: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
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
            labelText: '${context.appLocalization.labelCountry} (*)',
            labelStyle: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
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
        maxLength: 80,
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
            labelText: '${context.appLocalization.labelDirection} (*)',
            labelStyle: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
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
        maxLength: 15,
        keyboardType: TextInputType.number,
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
            labelText: '${context.appLocalization.labelMPPS} (*)',
            labelStyle: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
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
        maxLength: 15,
        keyboardType: TextInputType.number,
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
            labelText: '${context.appLocalization.labelCM} (*)',
            labelStyle: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
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
        maxLength: 30,
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
            labelText: '${context.appLocalization.labelSpeciality} (*)',
            labelStyle: const TextStyle(
                fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  Widget _inputBdate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.appLocalization.labelDateOfBirth} (*)',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          TextFormField(

            readOnly: true,
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
                  text: '$dateDay/$dateMonth/${selectedDate!.year}');
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
      BlocProvider.of<ImageProfileBloc>(context)
          .add(ValidatePermissionGalleryEvent());
    } else if (option == 2) {
      BlocProvider.of<ImageProfileBloc>(context)
          .add(ValidatePermissionCameraEvent());
      // await _selectImageCamera(context);
    } else if (option == 3) {
      BlocProvider.of<ImageProfileBloc>(context).add(CleanImageByProfile());
    }
  }

  Future<int> _showChoiceDialog() async {
    int selectionOption = 0;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () => backButtonActions(),
            child: AlertDialog(
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
                              context.pop();
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
            ),
          );
        });
    return selectionOption;
  }

  Widget _digitalSignatureDoctor(Uint8List? doctorSignatureBuild) {
    if (doctorSignatureBuild != null) {
      return Image.memory(
        doctorSignatureBuild,
        height: 250,
      );
    } else {
      return const SizedBox();
    }
  }
}
