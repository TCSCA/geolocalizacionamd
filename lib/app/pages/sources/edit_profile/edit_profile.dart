import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/edit_profile/widgets/build_textfield_widget.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/bloc/profile_bloc.dart';

import '../../../core/controllers/profile_controller.dart';
import '../../../shared/method/back_button_action.dart';
import '../../widgets/common_widgets.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

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

  @override
  Widget build(BuildContext context) {

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
                labelText: 'Documento de Identidad',
                placeHolder: state.profileModel.identificationDocument ?? '',
                isReadOnly: false,
                textController: identificationDocumentCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'Correo Electrónico',
                placeHolder: state.profileModel.email ?? '',
                isReadOnly: false,
                textController: emailCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'Género',
                placeHolder: state.profileModel.gender ?? '',
                isReadOnly: false,
                textController: genderCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'Fecha de Nacimiento',
                placeHolder:
                    '${state.profileModel.dayBirthday}-${state.profileModel.monthBirthday}-${state.profileModel.yearBirthday}',
                isReadOnly: false,
                textController: birthdayCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'Numero de Teléfono',
                placeHolder: state.profileModel.phoneNumber ?? '',
                isReadOnly: false,
                textController: phoneNumberCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'Otro teléfono',
                placeHolder: state.profileModel.otherNumber ?? '',
                isReadOnly: false,
                textController: otherNumberCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'País',
                placeHolder: state.profileModel.city ?? '',
                isReadOnly: true,
                textController: cityCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'Estado',
                placeHolder: state.profileModel.state ?? '',
                isReadOnly: false,
                textController: stateCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'Ciudad',
                placeHolder: state.profileModel.country ?? '',
                isReadOnly: false,
                textController: countryCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'Dirección',
                placeHolder: state.profileModel.direction ?? '',
                isReadOnly: false,
                textController: directionCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'M.P.P.S',
                placeHolder: '0000000000',
                isReadOnly: true,
                textController: cmppsCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'C.M',
                placeHolder: '0000000000',
                isReadOnly: true,
                textController: cmCtrl,
              ),
              BuildTextFieldWidget(
                labelText: 'Especialidad',
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
                        print(identificationDocumentCtrl);
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
    identificationDocumentCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.identificationDocument));
    emailCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.email));

    genderCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.gender));

    birthdayCtrl = TextEditingController(text: context.select((ProfileBloc profileBloc) {
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

    cityCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.city));

    stateCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.state));

    countryCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.country));

    directionCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.direction));

    /*cmppsCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.cmpps));

    cmCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.gender));*/

    specialityCtrl = TextEditingController(
        text: context.select((ProfileBloc profileBloc) =>
        profileBloc.profileModel?.speciality));
  }
}
