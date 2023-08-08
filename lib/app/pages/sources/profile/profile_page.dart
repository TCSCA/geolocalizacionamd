import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/bloc/profile_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/dialog/custom_dialog_box.dart';
import '../../../shared/loading/loading_builder.dart';
import '../../../shared/method/back_button_action.dart';
import '../../constants/app_constants.dart';
import '../../messages/app_messages.dart';
import '../../routes/geoamd_route.dart';
import '../navigation/bloc/navigation_bloc.dart';
import '/app/pages/widgets/common_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                child: GestureDetector(
                  onTap: () {},
                  child: const ListViewProfileWidget(),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xff2B5178),
              heroTag: 'button-edit-profile',
              child: const Icon(Icons.edit),
              onPressed: () {
                context.go(GeoAmdRoutes.editProfile, extra: NavigationBloc());
              },),
          ),
        ),
      );
  }
}

class ListViewProfileWidget extends StatelessWidget {
  const ListViewProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileInitial) {
          context.read<ProfileBloc>().add(GetProfileEvent());
        } else if (state is ProfileLoadingState) {
          LoadingBuilder(context)
              .showLoadingIndicator('Cargando perfil del doctor');
        } else if (state is ProfileSuccessState) {
          LoadingBuilder(context).hideOpenDialog();
        } else if (state is ProfileErrorState) {
          LoadingBuilder(context).hideOpenDialog();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages()
                      .getMessageTitle(context, AppConstants.statusError),
                  descriptions:
                  AppMessages().getMessage(context, state.messageError),
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
        if (state is ProfileSuccessState) {
          return ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/profile_default.png'),
                              fit: BoxFit.cover)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              _ProfileDataWidget(
                  title: context.appLocalization.labelFullName,
                  subtitle: state.profileModel.fullName ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: context.appLocalization.labelIdentificationDocument,
                  subtitle: '${state.profileModel.documentType}-${state
                      .profileModel.identificationDocument}' ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: context.appLocalization.labelEmail,
                  subtitle: state.profileModel.email ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'Género', subtitle: state.profileModel.gender ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'Fecha de Nacimiento',
                  subtitle:
                  '${state.profileModel.dayBirthday}-${state.profileModel
                      .monthBirthday}-${state.profileModel.yearBirthday}'),
              const Divider(),
              _ProfileDataWidget(
                  title: 'Número de Teléfono',
                  subtitle: state.profileModel.phoneNumber ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'Otro teléfono',
                  subtitle: state.profileModel.otherNumber ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'País', subtitle: state.profileModel.country ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'Estado', subtitle: state.profileModel.state ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'Ciudad', subtitle: state.profileModel.city ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'Dirección',
                  subtitle: state.profileModel.direction ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'M.P.P.S', subtitle: state.profileModel.mpps ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'C.M', subtitle: state.profileModel.mc ?? ''),
              const Divider(),
              _ProfileDataWidget(
                  title: 'Especialidad',
                  subtitle: state.profileModel.speciality ?? ''),
              const Divider(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
             /* Padding(
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
                        context.go(
                            GeoAmdRoutes.editProfile, extra: NavigationBloc());
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
              )*/
            ],
          );
        } else if (state is ProfileInitial) {
          BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildTextField({required String labelText,
    required String placeHolder,
    required bool isReadOnly}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextField(
        readOnly: isReadOnly,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: labelText,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }
}

class _ProfileDataWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ProfileDataWidget({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
    );
  }
}
