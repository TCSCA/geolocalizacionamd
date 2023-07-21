import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/edit_profile/widgets/build_textfield_widget.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/bloc/profile_bloc.dart';

import '../../../core/controllers/profile_controller.dart';
import '../../../shared/method/back_button_action.dart';
import '../../widgets/common_widgets.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return /*BlocProvider.value(
      value: BlocProvider.of<ProfileBloc>(context),
      child:*/ WillPopScope(
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
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ProfileSuccessState) {
          return ListView(
            children: [
              BuildTextFieldWidget(
                labelText: 'Documento de Identidad',
                placeHolder: state.profileModel.identificationDocument ?? '',
                isReadOnly: true,
              ),
              BuildTextFieldWidget(
                labelText: 'Correo Electrónico',
                placeHolder: state.profileModel.email ?? '',
                isReadOnly: false,
              ),
              BuildTextFieldWidget(
                labelText: 'Género',
                placeHolder: state.profileModel.gender ?? '',
                isReadOnly: false,
              ),
              BuildTextFieldWidget(
                labelText: 'Fecha de Nacimiento',
                placeHolder:
                    '${state.profileModel.dayBirthday}-${state.profileModel.monthBirthday}-${state.profileModel.yearBirthday}',
                isReadOnly: false,
              ),
              BuildTextFieldWidget(
                labelText: 'Numero de Teléfono',
                placeHolder: state.profileModel.phoneNumber ?? '',
                isReadOnly: false,
              ),
              BuildTextFieldWidget(
                labelText: 'Otro teléfono',
                placeHolder: state.profileModel.otherNumber ?? '',
                isReadOnly: false,
              ),
              BuildTextFieldWidget(
                labelText: 'País',
                placeHolder: state.profileModel.city ?? '',
                isReadOnly: true,
              ),
              BuildTextFieldWidget(
                labelText: 'Estado',
                placeHolder: state.profileModel.state ?? '',
                isReadOnly: false,
              ),
              BuildTextFieldWidget(
                labelText: 'Ciudad',
                placeHolder: state.profileModel.country ?? '',
                isReadOnly: false,
              ),
              BuildTextFieldWidget(
                labelText: 'Dirección',
                placeHolder: state.profileModel.direction ?? '',
                isReadOnly: false,
              ),
              BuildTextFieldWidget(
                labelText: 'M.P.P.S',
                placeHolder: '0000000000',
                isReadOnly: true,
              ),
              BuildTextFieldWidget(
                labelText: 'C.M',
                placeHolder: '0000000000',
                isReadOnly: true,
              ),
              BuildTextFieldWidget(
                labelText: 'Especialidad',
                placeHolder: state.profileModel.speciality ?? '',
                isReadOnly: true,
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
                        context.read<ProfileBloc>().add(GetProfileEvent());
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
}
